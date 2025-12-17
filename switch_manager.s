
   	
		AREA    |.text|, CODE, READONLY
 
; This register controls the clock gating logic in normal Run mode
SYSCTL_PERIPH_GPIO EQU		0x400FE108	; SYSCTL_RCGC2_R (p291 datasheet de lm3s9b92.pdf)

; The GPIODATA register is the data register
GPIO_PORTD_BASE		EQU		0x40007000		; GPIO Port D (APB) base: 0x4000.7000 (p416 datasheet de lm3s9B92.pdf)

; Digital enable register
; To use the pin as a digital input or output, the corresponding GPIODEN bit must be set.
GPIO_O_DEN  		EQU 	0x0000051C  ; GPIO Digital Enable (p437 datasheet de lm3s9B92.pdf)

; Pul_up
GPIO_I_PUR   		EQU 	0x00000510  ; GPIO Pull-Up (p432 datasheet de lm3s9B92.pdf)

BROCHE6				EQU 	0x40		; bouton 1
BROCHE7				EQU		0x80		; bouton 2
BROCHE6_7			EQU		0xc0		; bouton 1 & bouton 2
	

		;; The EXPORT command specifies that a symbol can be accessed by other shared objects or executables.
		EXPORT SWITCH_INIT
		EXPORT READ_SWITCH1
		EXPORT READ_SWITCH2


SWITCH_INIT
		
	; ;; Enable the Port D peripheral clock
	ldr r12, = SYSCTL_PERIPH_GPIO  			;; RCGC2
	ldr r0, [r12]
	ORR r0, r0, #0x00000008
	str r0, [r12]
	
	; ;; "There must be a delay of 3 system clocks before any GPIO reg. access  (p413 datasheet de lm3s9B92.pdf)
	nop
	nop	   
	nop

	ldr r11, = GPIO_PORTD_BASE+GPIO_I_PUR	;; Pull up
	ldr r0, [r11]
	orr r0, r0, #BROCHE6_7		
	str r0, [r11]
	
	ldr r11, = GPIO_PORTD_BASE+GPIO_O_DEN	;; Enable Digital Function 
	ldr r0, [r11]
	orr r0, r0, #BROCHE6_7		
	str r0, [r11]
	
	ldr r11, = GPIO_PORTD_BASE + (BROCHE6<<2)  ;; @data Register = @base + (mask<<2) ==> Switch
	ldr r12, = GPIO_PORTD_BASE + (BROCHE7<<2)  ;; @data Register = @base + (mask<<2) ==> Switch
	
	BX LR

; Lecture du sw1
READ_SWITCH1

	ldr r11, = GPIO_PORTD_BASE + (BROCHE6<<2)  ;; @data Register = @base + (mask<<2) ==> Switch
	LDR r5, [r11]
	cmp r5,#0x00
	BX LR

; Lecture du sw1
READ_SWITCH2

	ldr r12, = GPIO_PORTD_BASE + (BROCHE7<<2)  ;; @data Register = @base + (mask<<2) ==> Switch
	LDR r5, [r12]
	cmp r5,#0x00
	BX LR
		

;fin du programme
	NOP
	NOP
	END