In this project, I was tasked with designing an SPI slave connected to RAM. I created an SPI slave with identical specifications to serve as a reference model for checking the design. The RAM specifications are as follows:
![image](https://github.com/aboElhammd/SPI-slave-connected-to-single-port-ram-/assets/124165601/e26b7e76-1300-4082-82ee-4fb5d7b0d6d0)
The SPI slave design was based on the Finite State Machine (FSM) provided here: 
![image](https://github.com/aboElhammd/SPI-slave-connected-to-single-port-ram-/assets/124165601/26dac132-b214-4d61-b954-5e01a0e70f12)
Subsequently, I developed a verification plan encompassing constraints, functional coverage, and assertions. The verification plan for the SPI slave can be found here:
![image](https://github.com/aboElhammd/SPI-slave-connected-to-single-port-ram-/assets/124165601/e2c8a9d9-b2b9-4695-933c-544b6dba86c2)
Similarly, the verification plan for the RAM is available here:
![image](https://github.com/aboElhammd/SPI-slave-connected-to-single-port-ram-/assets/124165601/ff552339-070b-4fe7-8d64-4b4633a2f1d4)

Throughout the process, I identified and rectified all detected bugs until achieving satisfactory coverage sign-off and all the coverage reports are included in the files above and here is snippets of the important information in it :

branch coverage :
![image](https://github.com/aboElhammd/SPI-slave-connected-to-single-port-ram-/assets/124165601/8a3e8d02-dce3-4c4e-9c7e-36128e5767c4)

this missed one is due to the default in case that will not be triggered because we covered all cases of case statement so it will not get into default

statement coverage :

![image](https://github.com/aboElhammd/SPI-slave-connected-to-single-port-ram-/assets/124165601/0b74401f-97ac-4f09-b2e9-ec3f85475e25)
toggle coverage :

![image](https://github.com/aboElhammd/SPI-slave-connected-to-single-port-ram-/assets/124165601/f29fb1b3-f828-4058-bba5-c572cf0c0eae)

and here is a some snippets from questasim :

functional coverage :
![image](https://github.com/aboElhammd/SPI-slave-connected-to-single-port-ram-/assets/124165601/56c7418d-1a5e-4842-a0f6-f3c8e53557b1)
assertions coverage :
![image](https://github.com/aboElhammd/SPI-slave-connected-to-single-port-ram-/assets/124165601/30a63fe4-ad97-492b-985f-177dd09b3582)

and here is a random snippets from questasim :
![image](https://github.com/aboElhammd/SPI-slave-connected-to-single-port-ram-/assets/124165601/a32f5dee-c4eb-4191-a94a-ba4dcfc8a253)
![image](https://github.com/aboElhammd/SPI-slave-connected-to-single-port-ram-/assets/124165601/86cc40ac-355d-4bc6-9929-50eff91c3183)
![image](https://github.com/aboElhammd/SPI-slave-connected-to-single-port-ram-/assets/124165601/76643658-fcdf-4e08-942d-44e2e6cd57c6)

![image](https://github.com/aboElhammd/SPI-slave-connected-to-single-port-ram-/assets/124165601/b1461af7-56f5-4f30-9727-4d53e691b6d9)



