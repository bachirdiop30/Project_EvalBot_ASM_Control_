        AREA    |.text|, CODE, READONLY
        ENTRY
        EXPORT  __main

;; led_manager.s imports
        IMPORT  InitializeLeds
        IMPORT  EnableLed1
        IMPORT  EnableLed2
        IMPORT  EnableBothLeds
        IMPORT  DisableLeds
			
;; moteur_manager imports
		IMPORT	MOTEUR_INIT
		IMPORT	MOTEUR_DROIT_ON
		IMPORT  MOTEUR_DROIT_OFF
		IMPORT  MOTEUR_DROIT_AVANT
		IMPORT  MOTEUR_DROIT_ARRIERE
		IMPORT  MOTEUR_DROIT_INVERSE	
		IMPORT	MOTEUR_GAUCHE_ON
		IMPORT  MOTEUR_GAUCHE_OFF
		IMPORT  MOTEUR_GAUCHE_AVANT
		IMPORT  MOTEUR_GAUCHE_ARRIERE
		IMPORT  MOTEUR_GAUCHE_INVERSE

;; variables
DUREE   EQU     0x002FFFFF


;; entry point
__main
        
        ;; BL Branchement vers un lien (sous programme)

		; Configure les PWM + GPIO
		BL	MOTEUR_INIT	   		
		BL 	InitializeLeds
		
		; Activer les deux moteurs droit et gauche
		BL	MOTEUR_DROIT_ON
		BL	MOTEUR_GAUCHE_ON

		; Boucle de pilotage des 2 Moteurs (Evalbot tourne sur lui même)
loop	
		; Evalbot avance droit devant
		BL	MOTEUR_DROIT_AVANT	   
		BL	MOTEUR_GAUCHE_AVANT
		
		bl EnableLed1
		
	
		b	loop

		NOP
        END
