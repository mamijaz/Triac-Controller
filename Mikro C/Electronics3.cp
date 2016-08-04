#line 1 "D:/Study/PIC Mikro c/Electronics3/Electronics3.c"
#line 12 "D:/Study/PIC Mikro c/Electronics3/Electronics3.c"
unsigned temp;
unsigned short tempL, tempH, fraction;



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


char Reset_18B20()
{
  TRISE.F2 = 0 ;
  PORTE.F2  = 0;
 delay_us(480);
  TRISE.F2 = 1 ;
 delay_us(60);

 if ( PORTE.F2  == 0)
 {

 delay_us(480);
 return 0;
 }
 else
 {
 delay_us(480);
 return 1;
 }
}

void Write_18B20 (char Cmd){
 char i;
  TRISE.F2 = 1 ;
 for(i = 0; i < 8; i++)
 {
 if((Cmd & (1<<i))!= 0)
 {

  TRISE.F2 = 0 ;
  PORTE.F2  = 0;
 delay_us(1);
  TRISE.F2 = 1 ;
 delay_us(60);
 }
 else
 {

  TRISE.F2 = 0 ;
  PORTE.F2  = 0;
 delay_us(60);
  TRISE.F2 = 1 ;
 }
 }
}

char Read_18B20 ()
{
 char i,result = 0;
  TRISE.F2 = 1 ;
 for(i = 0; i < 8; i++)
 {
  TRISE.F2 = 0 ;
  PORTE.F2  = 0;
 delay_us(2);
  TRISE.F2 = 1 ;
 if( PORTE.F2  != 0)
 result |= 1<<i;
 delay_us(60);
 }
 return result;
}

char *text = "000.0000";
const unsigned short TEMP_RESOLUTION = 12;

void Display_Temperature(unsigned int temp2write)
{
 const unsigned short RES_SHIFT = TEMP_RESOLUTION - 8;
 char temp_whole;
 unsigned int temp_fraction;


 if (temp2write & 0x8000)
 {
 text[0] = '-';
 temp2write = ~temp2write + 1;
 }


 temp_whole = temp2write >> RES_SHIFT ;


 if (text[0] != '-')
 {
 if (temp_whole/100)
 text[0] = temp_whole/100 + 48;
 else
 text[0] = '0';
 }

 text[1] = (temp_whole/10)%10 + 48;
 text[2] = temp_whole%10 + 48;


 temp_fraction = temp2write << (4-RES_SHIFT);
 temp_fraction &= 0x000F;
 temp_fraction *= 625;


 text[4] = temp_fraction/1000 + 48;
 text[5] = (temp_fraction/100)%10 + 48;
 text[6] = (temp_fraction/10)%10 + 48;
 text[7] = temp_fraction%10 + 48;
#line 139 "D:/Study/PIC Mikro c/Electronics3/Electronics3.c"
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Temp = ");
 Lcd_Out(1,8,text);
}
 unsigned char FlagReg;
sbit ZC at FlagReg.B0;

void interrupt(){
 if (INTCON.INTF){
 ZC = 1;
 INTCON.INTF = 0;
 }
}

void main()
{
 int counts;

 PORTB.F0=0;
 TRISB.F0 = 1;
 PORTD = 0;
 TRISD = 0;
 OPTION_REG.INTEDG = 0;
 INTCON.INTF = 0;
 INTCON.INTE = 1;
 INTCON.GIE = 1;

 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);

 Lcd_Out(1,1,"Electroncs 3");
 Lcd_Out(2,1,"Semester 4");
 Delay_ms(3000);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);


 ADCON1 |= 0x0F;
 delay_ms(1000);

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);

 if(!Reset_18B20()){
 Write_18B20( 0xCC );
 Write_18B20( 0x44 );
 delay_ms(750);

 Reset_18B20();
 Write_18B20( 0xCC );
 Write_18B20( 0xBE );

 temp = Read_18B20();
 temp = (Read_18B20() << 8) + temp;


 Display_Temperature(temp);
 }
 delay_ms(3000);
 Lcd_Cmd(_LCD_CLEAR);
 while(1)
 {

 if(counts==1000){
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Looped");
 if(!Reset_18B20()){
 Write_18B20( 0xCC );
 Write_18B20( 0x44 );
 delay_ms(750);

 Reset_18B20();
 Write_18B20( 0xCC );
 Write_18B20( 0xBE );

 temp = Read_18B20();
 temp = (Read_18B20() << 8) + temp;


 Display_Temperature(temp);
 }
 delay_ms(3000);
 counts=0;
 Lcd_Cmd(_LCD_CLEAR);
 }
 if (ZC){

 if(temp>30){
 PORTD.B0 = 1;
 delay_us(200);
 PORTD.B0 = 0;
 ZC = 0;
 }
 counts++;
 }
 }
}
