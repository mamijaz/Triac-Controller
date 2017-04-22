//librarys used
//Lcd and Conversion

//Temp senser 18b20 definitions
#define Skip_ROM 0xCC
#define Convert_T 0x44
#define Read_scratchpad 0xBE

#define Port_18B20 PORTE.F2
#define Tx_18B20 TRISE.F2 = 0
#define Rx_18B20 TRISE.F2 = 1
unsigned temp;
unsigned short tempL, tempH, fraction;
//Temp senser definitions ends

// LCD module connections
sbit LCD_RS at RB2_bit;
sbit LCD_EN at RB3_bit;
sbit LCD_D4 at RB4_bit;
sbit LCD_D5 at RB5_bit;
sbit LCD_D6 at RB6_bit;
sbit LCD_D7 at RB7_bit;

sbit LCD_RS_Direction at TRISB2_bit;
sbit LCD_EN_Direction at TRISB3_bit;
sbit LCD_D4_Direction at TRISB4_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D7_Direction at TRISB7_bit;
// End LCD module connections

char Reset_18B20()
{
     Tx_18B20;                        // Tris = 0 (output)
     Port_18B20 = 0;                  // set pin# to low (0)
     delay_us(480);                      // 1 wire require time delay
     Rx_18B20;                        // Tris = 1 (input)
     delay_us(60);                    // 1 wire require time delay

     if (Port_18B20 == 0)
     {
        // if there is a presence pluse
        delay_us(480);
        return 0;                       // return 0 ( 1-wire is presence)
     }
     else
     {
        delay_us(480);
        return 1;                       // return 1 ( 1-wire is NOT presence)
     }
}

void Write_18B20 (char Cmd){
     char i;
     Rx_18B20;                        // set pin# to input (1)
     for(i = 0; i < 8; i++)           //Command 8 bits
     {
        if((Cmd & (1<<i))!= 0)
        {
           // write 1
           Tx_18B20;                      // set pin# to output (0)
           Port_18B20 = 0;                // set pin# to low (0)
           delay_us(1);                  // 1 wire require time delay
           Rx_18B20;                      // set pin# to input (release the bus)
           delay_us(60);                  // 1 wire require time delay
        }
        else
        {
           //write 0
           Tx_18B20;                      // set pin# to output (0)
           Port_18B20 = 0;                // set pin# to low (0)
           delay_us(60);                  // 1 wire require time delay
           Rx_18B20;                      // set pin# to input (release the bus)
        }
     }
}

char Read_18B20 ()
{
     char i,result = 0;
     Rx_18B20;                        // TRIS is input(1)
     for(i = 0; i < 8; i++)          //Default ouput 12bits
     {
      Tx_18B20;                       // TRIS is output(0)
      Port_18B20 = 0;                 // genarate low pluse for 2us
      delay_us(2);
      Rx_18B20;                       // TRIS is input(1) release the bus
      if(Port_18B20 != 0)
      result |= 1<<i;
      delay_us(60);                   // wait for recovery time
     }
     return result;
}

char *text = "000.0000";
const unsigned short TEMP_RESOLUTION = 12; //For the sensor model resolution is fixed and is 12

void Display_Temperature(unsigned int temp2write)
{
    const unsigned short RES_SHIFT = TEMP_RESOLUTION - 8;
    char temp_whole;
    unsigned int temp_fraction;

    // Check if temperature is negative
    if (temp2write & 0x8000)    // if temperature is negative, the highest bit will be 1  .
    {
         text[0] = '-';
         temp2write = ~temp2write + 1;      //Doing two's complement to calculate the absolute value
    }

    // Extract temp_whole
    temp_whole = temp2write >> RES_SHIFT ;

    // Convert temp_whole to characters
    if (text[0] != '-')
    {
        if (temp_whole/100)
           text[0] = temp_whole/100  + 48;
        else
           text[0] = '0';
    }

    text[1] = (temp_whole/10)%10 + 48;             // Extract tens digit
    text[2] =  temp_whole%10     + 48;             // Extract ones digit

    // Extract temp_fraction and convert it to unsigned int
    temp_fraction  = temp2write << (4-RES_SHIFT);
    temp_fraction &= 0x000F;
    temp_fraction *= 625;

    // Convert temp_fraction to characters
    text[4] =  temp_fraction/1000    + 48;         // Extract thousands digit
    text[5] = (temp_fraction/100)%10 + 48;         // Extract hundreds digit
    text[6] = (temp_fraction/10)%10  + 48;         // Extract tens digit
    text[7] =  temp_fraction%10      + 48;         // Extract ones digit

   /* IntToStr(text,txt);
    Ltrim(txt);   */
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Out(1,1,"Temp = ");
    Lcd_Out(1,8,text);
}
                                                                                                              unsigned char FlagReg;
sbit ZC at FlagReg.B0;

void interrupt(){
     if (INTCON.INTF){          //INTF flag raised, so external interrupt occured
        ZC = 1;
        INTCON.INTF = 0;
     }
}

void main()
{
 int counts;

 PORTB.F0=0;
 TRISB.F0 = 1;              //RB0 input for interrupt
 PORTD = 0;
 TRISD = 0;                 //PORTD all output
 OPTION_REG.INTEDG = 0;      //interrupt on falling edge
 INTCON.INTF = 0;           //clear interrupt flag
 INTCON.INTE = 1;           //enable external interrupt
 INTCON.GIE = 1;            //enable global interrupt
 
  Lcd_Init();
  Lcd_Cmd(_LCD_CLEAR);          // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);     // Cursor off

  Lcd_Out(1,1,"Electroncs 3");
  Lcd_Out(2,1,"Semester 4");
  Delay_ms(3000);
  Lcd_Cmd(_LCD_CLEAR);          // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);     // Cursor off


  ADCON1 |= 0x0F;                   // Configure AN pins as digital
  delay_ms(1000);
  
  Lcd_Cmd(_LCD_CLEAR);          // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);     // Cursor off

  if(!Reset_18B20()){
        Write_18B20(Skip_ROM);
        Write_18B20(Convert_T);
        delay_ms(750);

        Reset_18B20();
        Write_18B20(Skip_ROM);
        Write_18B20(Read_scratchpad);

        temp =  Read_18B20();
        temp = (Read_18B20() << 8) + temp;

        //--- Format and display result on Lcd
        Display_Temperature(temp);
  }
  delay_ms(3000);
  Lcd_Cmd(_LCD_CLEAR);          // Clear display
  while(1)
  {

     if(counts==1000){
        Lcd_Cmd(_LCD_CLEAR);          // Clear display
        Lcd_Out(1,1,"Looped");
        if(!Reset_18B20()){
          Write_18B20(Skip_ROM);
          Write_18B20(Convert_T);
          delay_ms(750);

          Reset_18B20();
          Write_18B20(Skip_ROM);
          Write_18B20(Read_scratchpad);

          temp =  Read_18B20();
          temp = (Read_18B20() << 8) + temp;

          //--- Format and display result on Lcd
          Display_Temperature(temp);
        }
        delay_ms(3000);
        counts=0;
        Lcd_Cmd(_LCD_CLEAR);          // Clear display
     }
     if (ZC){ //zero crossing occurred
        //delay_ms(1);
        if(temp>30){
          PORTD.B0 = 1; //Send a pulse
          delay_us(200);
          PORTD.B0 = 0;
          ZC = 0;
        }
        counts++;
     }
   }
}