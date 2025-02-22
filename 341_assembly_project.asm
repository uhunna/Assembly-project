.STACK 100H

.DATA

    welcome_msg db "Welcome to the Quiz Game by HUNNA and ADILA!", 0Dh, 0Ah, "$"
    start_msg db "Press 'S' to Start or 'Q' to Quit: ", "$"
    invalid_msg db "Invalid input. Please try again.", 0Dh, 0Ah, "$"
    question_prompt db 0Dh, 0Ah, "Question ", "$"
    game_over_msg db 0Dh, 0Ah, "Game Over! Your Final Score is: ", "$"
    exit_msg db 0Dh, 0Ah, "Thanks for playing!", 0Dh, 0Ah, "$"
    replay_msg db 0Dh, 0Ah, "Press 'R' to Replay or 'Q' to Quit: ", "$"
    correct_msg db "Correct answer! Lives remaining: ", "$"
    wrong_msg db "Wrong answer! Lives remaining: ", "$"
    newline db 0Dh, 0Ah, "$"
    new_high_score_msg db 0Dh, 0Ah, "New High Score!", 0Dh, 0Ah, "$"
    high_score_msg db 0Dh, 0Ah, "Highest Score: ", "$" 
    lifeline_msg db "Lifeline used! One incorrect option removed.", 0Dh, 0Ah, "$"
    already_used_msg db "You have already used the lifeline.", 0Dh, 0Ah, "$"   
    initial_msg db "You have 3 lives and 1 lifeline. Press 'L' to use lifeline.", 0Dh, 0Ah, "$"

    
    questions db "1. What is the national flower of Bangladesh?          $        "
              db "2. What is the name of the largest ocean in the world? $        "
              db "3. What is the longest bone in your body?              $        "
              db "4. What is the fear of spiders called?                 $        "
              db "5. Which Bangladeshi is the first to win a Nobel Prize?$        "
              db "6. Which galaxy is closest to the Milky Way Galaxy?    $        "
              db "7. Who painted the Mona Lisa?                          $        "
              db "8. When is the Victory day in Bangladesh?              $        "
              db "9. How many teeth does an adult human have?            $        "
              db "10. What is the largest mangrove forest in the world?  $        "

    options   db "A) Rose           B) Marigold      C) Water Lily        $       "
              db "A) Pacific Ocean  B) Indian Ocean  C) Atlantic Ocean    $       "
              db "A) Tibia          B) Humerus       C) Femur             $       "
              db "A) Acrophobia     B) Arachnophobia C) Claustrophobia    $       "
              db "A) Sheikh Mujib   B) Ziaur Rahman  C) Dr Yunus          $       "
              db "A) Triangulum     B) Andromeda     C) Whirlpool         $       "
              db "A) Michelangelo   B) Van Gogh      C) Leonardo Da Vinci $       "
              db "A) 16th December  B) 25th March    C) 15th August       $       "
              db "A) 28             B) 32            C) 31                $       "
              db "A) Sundarbans     B) Congo Forest  C) Amazon Rainforest $       " 
                                                                         
    l_options db "B) Marigold        C) Water Lily                        $       "
              db "A) Pacific Ocean   C) Atlantic Ocean                    $       "
              db "B) Humerus         C) Femur                             $       "
              db "B) Arachnophobia   C) Claustrophobia                    $       "
              db "A) Sheikh Mujib    C) Dr Yunus                          $       "
              db "B) Andromeda       C) Whirlpool                         $       "
              db "B) Van Gogh        C) Leonardo Da Vinci                 $       "
              db "A) 16th December   C) 15th August                       $       "
              db "A) 28              B) 32                                $       "
              db "A) Amazon Rainforest C) Sundarbans                      $       "
                                                                      
                   


    correct_answers db 'C', 'A', 'C', 'B', 'C', 'B', 'C', 'A', 'B', 'A'

    current_score dw 0          
    highest_score dw 0         
    lives dw 3                  
    lifeline_used db 0   
           

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

   
    mov dx, offset welcome_msg
    call print_string

start_menu:
    mov dx, offset start_msg
    call print_string
    call get_input
    cmp al, 'S'
    je start_game
    cmp al, 'Q'
    je exit_game
    mov dx, offset invalid_msg
    call print_string
    jmp start_menu
 
 
start_game:
    ; newline
    mov dx, offset newline
    call print_string 
      
    mov dx, offset initial_msg
    call print_string  
    
    ; newline 
    mov dx, offset newline
    call print_string  
    
    mov cx, 10          
    mov si, 0          
    mov current_score, 0 
    mov lives, 3        
    mov lifeline_used, 0 
 
 
questions_loop:
    ; Check for lives and loop
    cmp lives, 0
    je game_over
    cmp si, 10          
    je game_over         
    
    ; question prompt
    mov dx, offset question_prompt
    call print_string

    ; question number 
    mov ax, si         
    add ax, 1        
    call print_number   


    ; newline
    mov dx, offset newline
    call print_string

    ; Print questions
    lea bx, questions
    mov ax, si
    mov cx, 64        
    mul cx           
    add bx, ax       
    mov dx, bx
    call print_string

    ;newline
    mov dx, offset newline
    call print_string

    ; Print the options
    lea bx, options
    mov ax, si
    mov cx, 64       
    mul cx           
    add bx, ax       
    mov dx, bx
    call print_string

    ; newline
    mov dx, offset newline
    call print_string

    call get_input

    cmp al, 'L'
    je use_lifeline

    ;Check for valid input
    cmp al, 'A'
    je validate_answer
    cmp al, 'B'
    je validate_answer
    cmp al, 'C'
    je validate_answer
    mov dx, offset invalid_msg
    call print_string
    jmp questions_loop      
 
    
use_lifeline:
    ; Check if lifeline is already used
    cmp lifeline_used, 1
    je lifeline_already_used
    
    mov lifeline_used, 1
    
    ; newline
    mov dx, offset newline
    call print_string
    
    mov dx, offset lifeline_msg
    call print_string
    
    ; newline
    mov dx, offset newline
    call print_string                   
                       
    ; lifeline options
    lea bx, l_options  
    mov ax, si                
    mov cx, 64              
    mul cx
    add bx, ax                

    mov dx, bx
    call print_string

    ; newline
    mov dx, offset newline
    call print_string

    ; Wait for new input
    call get_input

    ; Validate input
    cmp al, 'A'
    je validate_answer
    cmp al, 'B'
    je validate_answer
    cmp al, 'C'
    je validate_answer

    ; Invalid input
    mov dx, offset invalid_msg
    call print_string

    lea bx, l_options 
    mov ax, si                
    mov cx, 64                
    mul cx
    add bx, ax                

    mov dx, bx
    call print_string

    ; newline
    mov dx, offset newline
    call print_string

    call get_input
    jmp validate_answer
                          
                          
lifeline_already_used:
    mov dx, offset already_used_msg
    call print_string
    jmp questions_loop


validate_answer:
    lea bx, correct_answers
    add bx, si
    cmp al, [bx]       
    jne wrong_answer
    add current_score, 5
    mov dx, offset correct_msg
    call print_string
    mov ax, lives
    call print_number 
    ; newline
    mov dx, offset newline
    call print_string
    jmp skip_score


wrong_answer:
    dec lives
    mov dx, offset wrong_msg
    call print_string
    mov ax, lives
    call print_number
    ; newline
    mov dx, offset newline
    call print_string

    
skip_score:
    inc si              
    loop questions_loop


game_over:
    ; Game over
    mov dx, offset game_over_msg
    call print_string
    mov ax, current_score
    call print_number

    ; Check for high score
    mov ax, current_score
    cmp ax, highest_score
    jbe display_high_score

    mov highest_score, ax
    mov dx, offset new_high_score_msg
    call print_string
    jmp replay_or_quit
 
 
display_high_score:
    mov dx, offset high_score_msg
    call print_string
    mov ax, highest_score
    call print_number
 
 
replay_or_quit:
    mov dx, offset replay_msg
    call print_string
    call get_input
    cmp al, 'R'
    je start_game
    cmp al, 'Q'
    je exit_game
    mov dx, offset invalid_msg
    call print_string
    jmp replay_or_quit


exit_game:
    mov dx, offset exit_msg
    call print_string
    mov ax,, 4C00H
    INT 21H


print_string PROC
    mov ah, 09h
    int 21h
    ret
print_string ENDP
 
 
get_input PROC
    mov ah, 01h
    int 21h
    ret
get_input ENDP


print_number PROC

    push ax
    push bx
    mov bx, 10

    MOV CX,0

convert_digits:
    mov dx, 0
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne convert_digits

print_digits:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop print_digits

    pop bx
    pop ax
    ret
print_number ENDP


END MAIN


