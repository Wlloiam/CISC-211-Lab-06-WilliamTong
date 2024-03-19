/*** asmFunc.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

#include <xc.h>

/* Tell the assembler that what follows is in data memory    */
.data
.align
 
/* define and initialize global variables that C can access */

.global dividend,divisor,quotient,mod,we_have_a_problem
.type dividend,%gnu_unique_object
.type divisor,%gnu_unique_object
.type quotient,%gnu_unique_object
.type mod,%gnu_unique_object
.type we_have_a_problem,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
 * If you want these to be 0 every time asmFunc gets called, you must set
 * them to 0 at the start of your code!
 */
dividend:          .word     0  
divisor:           .word     0  
quotient:          .word     0  
mod:               .word     0 
we_have_a_problem: .word     0

 /* Tell the assembler that what follows is in instruction memory    */
.text
.align

    
/********************************************************************
function name: asmFunc
function description:
     output = asmFunc ()
     
where:
     output: 
     
     function description: The C call ..........
     
     notes:
        None
          
********************************************************************/    
.global asmFunc
.type asmFunc,%function
asmFunc:   

    /* save the caller's registers, as required by the ARM calling convention */
    push {r4-r11,LR}
 
.if 0
    /* profs test code. */
    mov r0,r0
.endif
    
    /** note to profs: asmFunc.s solution is in Canvas at:
     *    Canvas Files->
     *        Lab Files and Coding Examples->
     *            Lab 5 Division
     * Use it to test the C test code */
    
    /*** STUDENTS: Place your code BELOW this line!!! **************/
    //load intitial values for later modification
    mov r10,0			  //storing 0 in r10 to modify the outputs later
    mov r11,1			  //storing 1 in r11 to modify the outputs later
    
    /** storing input from C code to the address of dividend and divisor **/
    ldr r5,=dividend	    //storing memory location of divident in r5
    str r0,[r5]		    //storing input dividend in memory location of dividend
    ldr r5,=divisor	    //storing memory location of dividend in r5
    str r1,[r5]		    //storing input divisor to memory location of divisor
    //setting 0 to all outputs quotient,mod,we_have_a_problem 
    ldr r6,=quotient	    //storing memory location of quotient in r6
    str r10,[r6]	    //storing 0 in memory location of quotient
    ldr r7,=mod		    //storing memory location of mod in r7
    str r10,[r7]	    //storing 0 in memory location of mod
    ldr r8,= we_have_a_problem	//storing memory location of we_have_a_problem in r8
    str r10,[r8]		//storing 0 in memory location of we_have_a_problem
    
    adds r0,r0,0		//for checking whether input dividend is 0 or not
    beq error_happen		//if the dividend is equal to 0, error_happen will run
    adds r1,r1,0		//for checking whether input divisor is 0 or not
    beq error_happen		//if the divisor is equal to 0, error_happen will run
    
    cmp r1,r0			//for checking divisor is greater than, or equal, or not by comparing two numbers
    bhi greater_divisor		//if the divisor is greater than dividend,greater_divisor will run (for unsigned number)
    beq equal_case		//if the divisor is equal dividend, equal_case will run (for unsigned number)
    
    ldr r9,[r6]			//sotring the value of quotient in r9
    /**This is division_by_subtraction branch and it will perfrom as a loop until the dividend is lesser or equal to the divisor **/
    division_by_subtraction:
	add r9,r9,1	    //the value of r9 is increased by 1 and it is for quotient, r9 = r9 + 1
	sub r0,r0,r1	    //subtracting the dividend to divisor, r0 = r0 - divisor in which the very first case is r0 = dividend - divisor
	cmp r1,r0	    //comparing the subtraction result r0 with divisor
	bls  division_by_subtraction	    // if the divisor is less than or equal to the subtraction result r0, 
					    //it will run division_by_subtraction, otherwise go to the next line
	str r9,[r6]	    //storing r9 value in quotient
	str r0,[r7]	    //storing r0 value in mod
	mov r0,r6	    //storing the address of quotient in r0
    b done		    //This will direct the program to the done branch
    
    /**This branch is will run, when divisor > dividend **/
    greater_divisor:
	str r0,[r7]	    //storing the value of dividend in mod
	mov r0,r6	    //storing the address of quotient in r0
	b done		    //This will direct the program to the done branch

    /**This branch will run, when divisor == dividend **/
    equal_case:
	str r11,[r6]	    //storing 1 in quotient
	str r10,[r7]	    //storing 0 in mod
	mov r0,r6	    //storing the address of quotient in r0
	b done		    //This will direct the program to the done branch
    /**This branch will run, when either divisor is 1 or dividend is 1, divided == 1 or divisor == 1 **/
    error_happen:
	ldr r5,= we_have_a_problem	//storing the address of we_have_a_problem in r5
	str r11,[r5]			//storing 1 in memory location of we_have_a_problem, we_have_a_problem = 1
	mov r0,r6	    //storing the address of quotient in r0
	b   done	    //This will direct the program to the done branch
    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
    mov r0,r0 /* these are do-nothing lines to deal with IDE mem display bug */
    mov r0,r0 /* this is a do-nothing line to deal with IDE mem display bug */

screen_shot:    pop {r4-r11,LR}

    mov pc, lr	 /* asmFunc return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




