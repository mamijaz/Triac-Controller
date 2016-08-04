
_Reset_18B20:

;Electronics3.c,32 :: 		char Reset_18B20()
;Electronics3.c,34 :: 		Tx_18B20;                        // Tris = 0 (output)
	BCF        TRISE+0, 2
;Electronics3.c,35 :: 		Port_18B20 = 0;                  // set pin# to low (0)
	BCF        PORTE+0, 2
;Electronics3.c,36 :: 		delay_us(480);                      // 1 wire require time delay
	MOVLW      4
	MOVWF      R12+0
	MOVLW      28
	MOVWF      R13+0
L_Reset_18B200:
	DECFSZ     R13+0, 1
	GOTO       L_Reset_18B200
	DECFSZ     R12+0, 1
	GOTO       L_Reset_18B200
	NOP
;Electronics3.c,37 :: 		Rx_18B20;                        // Tris = 1 (input)
	BSF        TRISE+0, 2
;Electronics3.c,38 :: 		delay_us(60);                    // 1 wire require time delay
	MOVLW      99
	MOVWF      R13+0
L_Reset_18B201:
	DECFSZ     R13+0, 1
	GOTO       L_Reset_18B201
	NOP
	NOP
;Electronics3.c,40 :: 		if (Port_18B20 == 0)
	BTFSC      PORTE+0, 2
	GOTO       L_Reset_18B202
;Electronics3.c,43 :: 		delay_us(480);
	MOVLW      4
	MOVWF      R12+0
	MOVLW      28
	MOVWF      R13+0
L_Reset_18B203:
	DECFSZ     R13+0, 1
	GOTO       L_Reset_18B203
	DECFSZ     R12+0, 1
	GOTO       L_Reset_18B203
	NOP
;Electronics3.c,44 :: 		return 0;                       // return 0 ( 1-wire is presence)
	CLRF       R0+0
	GOTO       L_end_Reset_18B20
;Electronics3.c,45 :: 		}
L_Reset_18B202:
;Electronics3.c,48 :: 		delay_us(480);
	MOVLW      4
	MOVWF      R12+0
	MOVLW      28
	MOVWF      R13+0
L_Reset_18B205:
	DECFSZ     R13+0, 1
	GOTO       L_Reset_18B205
	DECFSZ     R12+0, 1
	GOTO       L_Reset_18B205
	NOP
;Electronics3.c,49 :: 		return 1;                       // return 1 ( 1-wire is NOT presence)
	MOVLW      1
	MOVWF      R0+0
;Electronics3.c,51 :: 		}
L_end_Reset_18B20:
	RETURN
; end of _Reset_18B20

_Write_18B20:

;Electronics3.c,53 :: 		void Write_18B20 (char Cmd){
;Electronics3.c,55 :: 		Rx_18B20;                        // set pin# to input (1)
	BSF        TRISE+0, 2
;Electronics3.c,56 :: 		for(i = 0; i < 8; i++)           //Command 8 bits
	CLRF       R4+0
L_Write_18B206:
	MOVLW      8
	SUBWF      R4+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Write_18B207
;Electronics3.c,58 :: 		if((Cmd & (1<<i))!= 0)
	MOVF       R4+0, 0
	MOVWF      R2+0
	MOVLW      1
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVF       R2+0, 0
L__Write_18B2040:
	BTFSC      STATUS+0, 2
	GOTO       L__Write_18B2041
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__Write_18B2040
L__Write_18B2041:
	MOVF       R0+0, 0
	ANDWF      FARG_Write_18B20_Cmd+0, 0
	MOVWF      R2+0
	MOVLW      0
	ANDWF      R0+1, 0
	MOVWF      R2+1
	MOVLW      0
	XORWF      R2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Write_18B2042
	MOVLW      0
	XORWF      R2+0, 0
L__Write_18B2042:
	BTFSC      STATUS+0, 2
	GOTO       L_Write_18B209
;Electronics3.c,61 :: 		Tx_18B20;                      // set pin# to output (0)
	BCF        TRISE+0, 2
;Electronics3.c,62 :: 		Port_18B20 = 0;                // set pin# to low (0)
	BCF        PORTE+0, 2
;Electronics3.c,63 :: 		delay_us(1);                  // 1 wire require time delay
	NOP
	NOP
	NOP
	NOP
	NOP
;Electronics3.c,64 :: 		Rx_18B20;                      // set pin# to input (release the bus)
	BSF        TRISE+0, 2
;Electronics3.c,65 :: 		delay_us(60);                  // 1 wire require time delay
	MOVLW      99
	MOVWF      R13+0
L_Write_18B2010:
	DECFSZ     R13+0, 1
	GOTO       L_Write_18B2010
	NOP
	NOP
;Electronics3.c,66 :: 		}
	GOTO       L_Write_18B2011
L_Write_18B209:
;Electronics3.c,70 :: 		Tx_18B20;                      // set pin# to output (0)
	BCF        TRISE+0, 2
;Electronics3.c,71 :: 		Port_18B20 = 0;                // set pin# to low (0)
	BCF        PORTE+0, 2
;Electronics3.c,72 :: 		delay_us(60);                  // 1 wire require time delay
	MOVLW      99
	MOVWF      R13+0
L_Write_18B2012:
	DECFSZ     R13+0, 1
	GOTO       L_Write_18B2012
	NOP
	NOP
;Electronics3.c,73 :: 		Rx_18B20;                      // set pin# to input (release the bus)
	BSF        TRISE+0, 2
;Electronics3.c,74 :: 		}
L_Write_18B2011:
;Electronics3.c,56 :: 		for(i = 0; i < 8; i++)           //Command 8 bits
	INCF       R4+0, 1
;Electronics3.c,75 :: 		}
	GOTO       L_Write_18B206
L_Write_18B207:
;Electronics3.c,76 :: 		}
L_end_Write_18B20:
	RETURN
; end of _Write_18B20

_Read_18B20:

;Electronics3.c,78 :: 		char Read_18B20 ()
;Electronics3.c,80 :: 		char i,result = 0;
	CLRF       Read_18B20_result_L0+0
;Electronics3.c,81 :: 		Rx_18B20;                        // TRIS is input(1)
	BSF        TRISE+0, 2
;Electronics3.c,82 :: 		for(i = 0; i < 8; i++)          //Default ouput 12bits
	CLRF       R2+0
L_Read_18B2013:
	MOVLW      8
	SUBWF      R2+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Read_18B2014
;Electronics3.c,84 :: 		Tx_18B20;                       // TRIS is output(0)
	BCF        TRISE+0, 2
;Electronics3.c,85 :: 		Port_18B20 = 0;                 // genarate low pluse for 2us
	BCF        PORTE+0, 2
;Electronics3.c,86 :: 		delay_us(2);
	MOVLW      3
	MOVWF      R13+0
L_Read_18B2016:
	DECFSZ     R13+0, 1
	GOTO       L_Read_18B2016
;Electronics3.c,87 :: 		Rx_18B20;                       // TRIS is input(1) release the bus
	BSF        TRISE+0, 2
;Electronics3.c,88 :: 		if(Port_18B20 != 0)
	BTFSS      PORTE+0, 2
	GOTO       L_Read_18B2017
;Electronics3.c,89 :: 		result |= 1<<i;
	MOVF       R2+0, 0
	MOVWF      R1+0
	MOVLW      1
	MOVWF      R0+0
	MOVF       R1+0, 0
L__Read_18B2044:
	BTFSC      STATUS+0, 2
	GOTO       L__Read_18B2045
	RLF        R0+0, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__Read_18B2044
L__Read_18B2045:
	MOVF       R0+0, 0
	IORWF      Read_18B20_result_L0+0, 1
L_Read_18B2017:
;Electronics3.c,90 :: 		delay_us(60);                   // wait for recovery time
	MOVLW      99
	MOVWF      R13+0
L_Read_18B2018:
	DECFSZ     R13+0, 1
	GOTO       L_Read_18B2018
	NOP
	NOP
;Electronics3.c,82 :: 		for(i = 0; i < 8; i++)          //Default ouput 12bits
	INCF       R2+0, 1
;Electronics3.c,91 :: 		}
	GOTO       L_Read_18B2013
L_Read_18B2014:
;Electronics3.c,92 :: 		return result;
	MOVF       Read_18B20_result_L0+0, 0
	MOVWF      R0+0
;Electronics3.c,93 :: 		}
L_end_Read_18B20:
	RETURN
; end of _Read_18B20

_Display_Temperature:

;Electronics3.c,98 :: 		void Display_Temperature(unsigned int temp2write)
;Electronics3.c,105 :: 		if (temp2write & 0x8000)    // if temperature is negative, the highest bit will be 1  .
	BTFSS      FARG_Display_Temperature_temp2write+1, 7
	GOTO       L_Display_Temperature19
;Electronics3.c,107 :: 		text[0] = '-';
	MOVF       _text+0, 0
	MOVWF      FSR
	MOVLW      45
	MOVWF      INDF+0
;Electronics3.c,108 :: 		temp2write = ~temp2write + 1;      //Doing two's complement to calculate the absolute value
	COMF       FARG_Display_Temperature_temp2write+0, 1
	COMF       FARG_Display_Temperature_temp2write+1, 1
	INCF       FARG_Display_Temperature_temp2write+0, 1
	BTFSC      STATUS+0, 2
	INCF       FARG_Display_Temperature_temp2write+1, 1
;Electronics3.c,109 :: 		}
L_Display_Temperature19:
;Electronics3.c,112 :: 		temp_whole = temp2write >> RES_SHIFT ;
	MOVF       FARG_Display_Temperature_temp2write+0, 0
	MOVWF      R0+0
	MOVF       FARG_Display_Temperature_temp2write+1, 0
	MOVWF      R0+1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	MOVF       R0+0, 0
	MOVWF      Display_Temperature_temp_whole_L0+0
;Electronics3.c,115 :: 		if (text[0] != '-')
	MOVF       _text+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      45
	BTFSC      STATUS+0, 2
	GOTO       L_Display_Temperature20
;Electronics3.c,117 :: 		if (temp_whole/100)
	MOVLW      100
	MOVWF      R4+0
	MOVF       Display_Temperature_temp_whole_L0+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Display_Temperature21
;Electronics3.c,118 :: 		text[0] = temp_whole/100  + 48;
	MOVF       _text+0, 0
	MOVWF      FLOC__Display_Temperature+0
	MOVLW      100
	MOVWF      R4+0
	MOVF       Display_Temperature_temp_whole_L0+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__Display_Temperature+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	GOTO       L_Display_Temperature22
L_Display_Temperature21:
;Electronics3.c,120 :: 		text[0] = '0';
	MOVF       _text+0, 0
	MOVWF      FSR
	MOVLW      48
	MOVWF      INDF+0
L_Display_Temperature22:
;Electronics3.c,121 :: 		}
L_Display_Temperature20:
;Electronics3.c,123 :: 		text[1] = (temp_whole/10)%10 + 48;             // Extract tens digit
	INCF       _text+0, 0
	MOVWF      FLOC__Display_Temperature+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       Display_Temperature_temp_whole_L0+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Div_8x8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__Display_Temperature+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;Electronics3.c,124 :: 		text[2] =  temp_whole%10     + 48;             // Extract ones digit
	MOVLW      2
	ADDWF      _text+0, 0
	MOVWF      FLOC__Display_Temperature+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       Display_Temperature_temp_whole_L0+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__Display_Temperature+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;Electronics3.c,127 :: 		temp_fraction  = temp2write << (4-RES_SHIFT);
	MOVF       FARG_Display_Temperature_temp2write+0, 0
	MOVWF      Display_Temperature_temp_fraction_L0+0
	MOVF       FARG_Display_Temperature_temp2write+1, 0
	MOVWF      Display_Temperature_temp_fraction_L0+1
;Electronics3.c,128 :: 		temp_fraction &= 0x000F;
	MOVLW      15
	ANDWF      FARG_Display_Temperature_temp2write+0, 0
	MOVWF      R0+0
	MOVF       FARG_Display_Temperature_temp2write+1, 0
	MOVWF      R0+1
	MOVLW      0
	ANDWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      Display_Temperature_temp_fraction_L0+0
	MOVF       R0+1, 0
	MOVWF      Display_Temperature_temp_fraction_L0+1
;Electronics3.c,129 :: 		temp_fraction *= 625;
	MOVLW      113
	MOVWF      R4+0
	MOVLW      2
	MOVWF      R4+1
	CALL       _Mul_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      Display_Temperature_temp_fraction_L0+0
	MOVF       R0+1, 0
	MOVWF      Display_Temperature_temp_fraction_L0+1
;Electronics3.c,132 :: 		text[4] =  temp_fraction/1000    + 48;         // Extract thousands digit
	MOVLW      4
	ADDWF      _text+0, 0
	MOVWF      FLOC__Display_Temperature+0
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CALL       _Div_16x16_U+0
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__Display_Temperature+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;Electronics3.c,133 :: 		text[5] = (temp_fraction/100)%10 + 48;         // Extract hundreds digit
	MOVLW      5
	ADDWF      _text+0, 0
	MOVWF      FLOC__Display_Temperature+0
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       Display_Temperature_temp_fraction_L0+0, 0
	MOVWF      R0+0
	MOVF       Display_Temperature_temp_fraction_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__Display_Temperature+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;Electronics3.c,134 :: 		text[6] = (temp_fraction/10)%10  + 48;         // Extract tens digit
	MOVLW      6
	ADDWF      _text+0, 0
	MOVWF      FLOC__Display_Temperature+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       Display_Temperature_temp_fraction_L0+0, 0
	MOVWF      R0+0
	MOVF       Display_Temperature_temp_fraction_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__Display_Temperature+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;Electronics3.c,135 :: 		text[7] =  temp_fraction%10      + 48;         // Extract ones digit
	MOVLW      7
	ADDWF      _text+0, 0
	MOVWF      FLOC__Display_Temperature+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       Display_Temperature_temp_fraction_L0+0, 0
	MOVWF      R0+0
	MOVF       Display_Temperature_temp_fraction_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__Display_Temperature+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;Electronics3.c,139 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Electronics3.c,140 :: 		Lcd_Out(1,1,"Temp = ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_Electronics3+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Electronics3.c,141 :: 		Lcd_Out(1,8,text);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       _text+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Electronics3.c,142 :: 		}
L_end_Display_Temperature:
	RETURN
; end of _Display_Temperature

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Electronics3.c,146 :: 		void interrupt(){
;Electronics3.c,147 :: 		if (INTCON.INTF){          //INTF flag raised, so external interrupt occured
	BTFSS      INTCON+0, 1
	GOTO       L_interrupt23
;Electronics3.c,148 :: 		ZC = 1;
	BSF        _FlagReg+0, 0
;Electronics3.c,149 :: 		INTCON.INTF = 0;
	BCF        INTCON+0, 1
;Electronics3.c,150 :: 		}
L_interrupt23:
;Electronics3.c,151 :: 		}
L_end_interrupt:
L__interrupt48:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Electronics3.c,153 :: 		void main()
;Electronics3.c,157 :: 		PORTB.F0=0;
	BCF        PORTB+0, 0
;Electronics3.c,158 :: 		TRISB.F0 = 1;              //RB0 input for interrupt
	BSF        TRISB+0, 0
;Electronics3.c,159 :: 		PORTD = 0;
	CLRF       PORTD+0
;Electronics3.c,160 :: 		TRISD = 0;                 //PORTD all output
	CLRF       TRISD+0
;Electronics3.c,161 :: 		OPTION_REG.INTEDG = 0;      //interrupt on falling edge
	BCF        OPTION_REG+0, 6
;Electronics3.c,162 :: 		INTCON.INTF = 0;           //clear interrupt flag
	BCF        INTCON+0, 1
;Electronics3.c,163 :: 		INTCON.INTE = 1;           //enable external interrupt
	BSF        INTCON+0, 4
;Electronics3.c,164 :: 		INTCON.GIE = 1;            //enable global interrupt
	BSF        INTCON+0, 7
;Electronics3.c,166 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;Electronics3.c,167 :: 		Lcd_Cmd(_LCD_CLEAR);          // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Electronics3.c,168 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);     // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Electronics3.c,170 :: 		Lcd_Out(1,1,"Electroncs 3");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_Electronics3+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Electronics3.c,171 :: 		Lcd_Out(2,1,"Semester 4");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_Electronics3+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Electronics3.c,172 :: 		Delay_ms(3000);
	MOVLW      77
	MOVWF      R11+0
	MOVLW      25
	MOVWF      R12+0
	MOVLW      79
	MOVWF      R13+0
L_main24:
	DECFSZ     R13+0, 1
	GOTO       L_main24
	DECFSZ     R12+0, 1
	GOTO       L_main24
	DECFSZ     R11+0, 1
	GOTO       L_main24
	NOP
	NOP
;Electronics3.c,173 :: 		Lcd_Cmd(_LCD_CLEAR);          // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Electronics3.c,174 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);     // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Electronics3.c,177 :: 		ADCON1 |= 0x0F;                   // Configure AN pins as digital
	MOVLW      15
	IORWF      ADCON1+0, 1
;Electronics3.c,178 :: 		delay_ms(1000);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main25:
	DECFSZ     R13+0, 1
	GOTO       L_main25
	DECFSZ     R12+0, 1
	GOTO       L_main25
	DECFSZ     R11+0, 1
	GOTO       L_main25
	NOP
;Electronics3.c,180 :: 		Lcd_Cmd(_LCD_CLEAR);          // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Electronics3.c,181 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);     // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Electronics3.c,183 :: 		if(!Reset_18B20()){
	CALL       _Reset_18B20+0
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main26
;Electronics3.c,184 :: 		Write_18B20(Skip_ROM);
	MOVLW      204
	MOVWF      FARG_Write_18B20_Cmd+0
	CALL       _Write_18B20+0
;Electronics3.c,185 :: 		Write_18B20(Convert_T);
	MOVLW      68
	MOVWF      FARG_Write_18B20_Cmd+0
	CALL       _Write_18B20+0
;Electronics3.c,186 :: 		delay_ms(750);
	MOVLW      20
	MOVWF      R11+0
	MOVLW      7
	MOVWF      R12+0
	MOVLW      17
	MOVWF      R13+0
L_main27:
	DECFSZ     R13+0, 1
	GOTO       L_main27
	DECFSZ     R12+0, 1
	GOTO       L_main27
	DECFSZ     R11+0, 1
	GOTO       L_main27
	NOP
	NOP
;Electronics3.c,188 :: 		Reset_18B20();
	CALL       _Reset_18B20+0
;Electronics3.c,189 :: 		Write_18B20(Skip_ROM);
	MOVLW      204
	MOVWF      FARG_Write_18B20_Cmd+0
	CALL       _Write_18B20+0
;Electronics3.c,190 :: 		Write_18B20(Read_scratchpad);
	MOVLW      190
	MOVWF      FARG_Write_18B20_Cmd+0
	CALL       _Write_18B20+0
;Electronics3.c,192 :: 		temp =  Read_18B20();
	CALL       _Read_18B20+0
	MOVF       R0+0, 0
	MOVWF      _temp+0
	CLRF       _temp+1
;Electronics3.c,193 :: 		temp = (Read_18B20() << 8) + temp;
	CALL       _Read_18B20+0
	MOVF       R0+0, 0
	MOVWF      R2+1
	CLRF       R2+0
	MOVF       _temp+0, 0
	ADDWF      R2+0, 0
	MOVWF      R0+0
	MOVF       R2+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _temp+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _temp+0
	MOVF       R0+1, 0
	MOVWF      _temp+1
;Electronics3.c,196 :: 		Display_Temperature(temp);
	MOVF       R0+0, 0
	MOVWF      FARG_Display_Temperature_temp2write+0
	MOVF       R0+1, 0
	MOVWF      FARG_Display_Temperature_temp2write+1
	CALL       _Display_Temperature+0
;Electronics3.c,197 :: 		}
L_main26:
;Electronics3.c,198 :: 		delay_ms(3000);
	MOVLW      77
	MOVWF      R11+0
	MOVLW      25
	MOVWF      R12+0
	MOVLW      79
	MOVWF      R13+0
L_main28:
	DECFSZ     R13+0, 1
	GOTO       L_main28
	DECFSZ     R12+0, 1
	GOTO       L_main28
	DECFSZ     R11+0, 1
	GOTO       L_main28
	NOP
	NOP
;Electronics3.c,199 :: 		Lcd_Cmd(_LCD_CLEAR);          // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Electronics3.c,200 :: 		while(1)
L_main29:
;Electronics3.c,203 :: 		if(counts==1000){
	MOVF       main_counts_L0+1, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__main50
	MOVLW      232
	XORWF      main_counts_L0+0, 0
L__main50:
	BTFSS      STATUS+0, 2
	GOTO       L_main31
;Electronics3.c,204 :: 		Lcd_Cmd(_LCD_CLEAR);          // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Electronics3.c,205 :: 		Lcd_Out(1,1,"Looped");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_Electronics3+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Electronics3.c,206 :: 		if(!Reset_18B20()){
	CALL       _Reset_18B20+0
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main32
;Electronics3.c,207 :: 		Write_18B20(Skip_ROM);
	MOVLW      204
	MOVWF      FARG_Write_18B20_Cmd+0
	CALL       _Write_18B20+0
;Electronics3.c,208 :: 		Write_18B20(Convert_T);
	MOVLW      68
	MOVWF      FARG_Write_18B20_Cmd+0
	CALL       _Write_18B20+0
;Electronics3.c,209 :: 		delay_ms(750);
	MOVLW      20
	MOVWF      R11+0
	MOVLW      7
	MOVWF      R12+0
	MOVLW      17
	MOVWF      R13+0
L_main33:
	DECFSZ     R13+0, 1
	GOTO       L_main33
	DECFSZ     R12+0, 1
	GOTO       L_main33
	DECFSZ     R11+0, 1
	GOTO       L_main33
	NOP
	NOP
;Electronics3.c,211 :: 		Reset_18B20();
	CALL       _Reset_18B20+0
;Electronics3.c,212 :: 		Write_18B20(Skip_ROM);
	MOVLW      204
	MOVWF      FARG_Write_18B20_Cmd+0
	CALL       _Write_18B20+0
;Electronics3.c,213 :: 		Write_18B20(Read_scratchpad);
	MOVLW      190
	MOVWF      FARG_Write_18B20_Cmd+0
	CALL       _Write_18B20+0
;Electronics3.c,215 :: 		temp =  Read_18B20();
	CALL       _Read_18B20+0
	MOVF       R0+0, 0
	MOVWF      _temp+0
	CLRF       _temp+1
;Electronics3.c,216 :: 		temp = (Read_18B20() << 8) + temp;
	CALL       _Read_18B20+0
	MOVF       R0+0, 0
	MOVWF      R2+1
	CLRF       R2+0
	MOVF       _temp+0, 0
	ADDWF      R2+0, 0
	MOVWF      R0+0
	MOVF       R2+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _temp+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _temp+0
	MOVF       R0+1, 0
	MOVWF      _temp+1
;Electronics3.c,219 :: 		Display_Temperature(temp);
	MOVF       R0+0, 0
	MOVWF      FARG_Display_Temperature_temp2write+0
	MOVF       R0+1, 0
	MOVWF      FARG_Display_Temperature_temp2write+1
	CALL       _Display_Temperature+0
;Electronics3.c,220 :: 		}
L_main32:
;Electronics3.c,221 :: 		delay_ms(3000);
	MOVLW      77
	MOVWF      R11+0
	MOVLW      25
	MOVWF      R12+0
	MOVLW      79
	MOVWF      R13+0
L_main34:
	DECFSZ     R13+0, 1
	GOTO       L_main34
	DECFSZ     R12+0, 1
	GOTO       L_main34
	DECFSZ     R11+0, 1
	GOTO       L_main34
	NOP
	NOP
;Electronics3.c,222 :: 		counts=0;
	CLRF       main_counts_L0+0
	CLRF       main_counts_L0+1
;Electronics3.c,223 :: 		Lcd_Cmd(_LCD_CLEAR);          // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Electronics3.c,224 :: 		}
L_main31:
;Electronics3.c,225 :: 		if (ZC){ //zero crossing occurred
	BTFSS      _FlagReg+0, 0
	GOTO       L_main35
;Electronics3.c,227 :: 		if(temp>30){
	MOVF       _temp+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main51
	MOVF       _temp+0, 0
	SUBLW      30
L__main51:
	BTFSC      STATUS+0, 0
	GOTO       L_main36
;Electronics3.c,228 :: 		PORTD.B0 = 1; //Send a pulse
	BSF        PORTD+0, 0
;Electronics3.c,229 :: 		delay_us(200);
	MOVLW      2
	MOVWF      R12+0
	MOVLW      75
	MOVWF      R13+0
L_main37:
	DECFSZ     R13+0, 1
	GOTO       L_main37
	DECFSZ     R12+0, 1
	GOTO       L_main37
;Electronics3.c,230 :: 		PORTD.B0 = 0;
	BCF        PORTD+0, 0
;Electronics3.c,231 :: 		ZC = 0;
	BCF        _FlagReg+0, 0
;Electronics3.c,232 :: 		}
L_main36:
;Electronics3.c,233 :: 		counts++;
	INCF       main_counts_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       main_counts_L0+1, 1
;Electronics3.c,234 :: 		}
L_main35:
;Electronics3.c,235 :: 		}
	GOTO       L_main29
;Electronics3.c,236 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
