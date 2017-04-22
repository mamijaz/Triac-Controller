# Triac Controller to control AC Power Output

The project is aimed to design a system which is capable of adjusting AC power output (In this fan speed with regurds to external temperature). The project uses DS18B20 temerature sensor to messure the external temperature which is then communicated to the PIC microcontroller using onewire communication, thereafter the power output to the fan is contrlled via adjusting the firing angle of triace depending on the temperature.

The firing angle is controled in the fallowing way
- An interuped is generated using an optocoupler at zero crosing of AC voltage
- The microcontroller then wait a variable amount of time depending on the temperature and triger the triac driver
- The triac driver then drives the triac to conduct AC voltages

The power output is determined by the time gap between the zero crossing signal and the triac driver signal.
