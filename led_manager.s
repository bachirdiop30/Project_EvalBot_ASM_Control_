    AREA |.text|, CODE, READONLY


; This register controls the clock gating logic in normal Run mode
SYSCTL_PERIPH_GPIO EQU		0x400FE108	; SYSCTL_RCGC2_R (p291 datasheet de lm3s9b92.pdf)

GPIO_O_DIR         EQU      0x00000400
GPIO_O_DR2R   		EQU 	0x00000500  
GPIO_O_DEN  		EQU 	0x0000051C 


GPIO_PORTF_BASE		EQU		0x40025000	; GPIO Port F : Pour les Leds


PIN4				EQU		0x10		; led1 sur broche 4
PIN5				EQU		0x20		; led2 sur broche 5
PIN4_5				EQU		0x30		; led1 sur broche 4 et led2 sur broche 5 

DISABLE_SIGNAL      EQU     0x000 


    ;; Fonctions a exporter pour les utiliser dans d'autres fichiers .s
    EXPORT InitializeLeds
    EXPORT EnableLed1
    EXPORT EnableLed2
    EXPORT EnableBothLeds
    EXPORT DisableLeds



InitializeLeds

    ldr r6, = SYSCTL_PERIPH_GPIO  			;; RCGC2
    mov r0, #0x00000028  	
    str r0, [r6]

    ;; delai de 3 tours d'horloge pour la configuration
    nop
    nop 
    nop

    ldr r6, = GPIO_PORTF_BASE+GPIO_O_DIR    ;; 1 Pin du portF en sortie (broche 4 : 00010000)
    ldr r0, = PIN4_5 	
    str r0, [r6]
	
	ldr r6, = GPIO_PORTF_BASE+GPIO_O_DEN	;; Enable Digital Function 
    ldr r0, = PIN4_5		
    str r0, [r6]
	
	ldr r6, = GPIO_PORTF_BASE+GPIO_O_DR2R	;; Choix de l'intensité de sortie (2mA)
    ldr r0, = PIN4_5			
    str r0, [r6]

    bx lr

EnableLed1

    ldr r6, = GPIO_PORTF_BASE + (PIN4_5<<2)  ;; @data Register = @base + (mask<<2) ==> LED1
    mov r3, #PIN4
    str r3, [r6]
    bx lr


EnableLed2
    ldr r6, = GPIO_PORTF_BASE + (PIN4_5<<2)  ;; @data Register = @base + (mask<<2) ==> LED1
    mov r3, #PIN5
    str r3, [r6]
    bx lr

EnableBothLeds
    ldr r6, = GPIO_PORTF_BASE + (PIN4_5<<2)  ;; @data Register = @base + (mask<<2) ==> LED1
    mov r3, #PIN4_5
    str r3, [r6]
    bx lr


DisableLeds
	ldr r2, = DISABLE_SIGNAL       					;; pour eteindre LED
    ldr r6, = GPIO_PORTF_BASE + (PIN4_5<<2)  ;; @data Register = @base + (mask<<2) ==> LED1
    str r2, [r6]
    bx lr
	



