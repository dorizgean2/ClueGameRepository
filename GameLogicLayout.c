/*  
    Made by Jeremyah Flowers and Doriz Concepcion for Duke ECE350 - CLUE game outline
    
    If you have not yet, please read the README for the project before editing the C-Outline as this will make your life
    (and my life) easier. Namely, make sure you understand the section labeled "Notes to editors" where you will find
    notes about c, examples of good vs. bad c code, and notes about assembly. 

    Code Description: C-Outline for the CLUE game logic assembled in "GameLogic.s". This outline can be used to track
    changes to the overall code structure and later debug unexpected behavior found in the assembly. Includes added 
    comments for readability as well as TODOs for the developers. The functionality used in this code is based on the 
    architecture of the CURRENT working processor, meaning any additional functionality must be added and tested prior 
    to being implemented in the ISA.
 
    When developing the C-code outline for the assembly, remember that each line will be mapped to the cooresponding
    line in (pseudo-)MIPS. This means using complex functions and/or long lines of codes is ill-advised, as this will 
    make it harder to map and debug code in assembly. Instead, it is preferred to used simple, clean logic that can be
    easily followed in C, assmebly, and by other programmers (i.e., me). If you would like an example of this done 
    in easily readable code, please review the sub-section "Examples of Good vs. Bad C Code for Conversion" found under
    the README in "Notes for Editors."

*/

// INCLUDE STATEMENTS ONLY USED IN C LAYOUT FOR EXCEPTIONS AND ARGUMENTS - In Assembly these are handled by setex

#include <stdio.h>
#include <stdlib.h>

// Global constants to be used in game logic 

const int MAX_RUNTIME = 20;		// Total times the game should be played
const int LO = 0;			// Button logic for OFF 
const int HI = 1;			// Button logic for ON
const int LOSE = 0;			// LOSE condition 
const int WIN = 1;			// WIN condition
// Global variables for game logic

char player_names[4][32] =  {"Miss Scarlett", "Colonel Mustard", "Chef White", "Reverend Green"};
char murderer_names[4][32] =  {"Scarlett", "Mustard", "White", "Green"};
int game_runtime; 			// Total times the game has been played
int players; 				// Total players in the game
int running;				// 1 if game is running, 0 otherwise
int murderer;				// chosen murderer	

// Sets global variables to use in game logic

void launch_game() {
    game_runtime = 0; 				// Sets game rounds = 0
    srand(17*players);				// Generates new seed at the start of the game 
    murderer = rand() % 3;				// Generates Random Murderer
}

// Handles exceptions after checking (button) inputs 

void use_exception() {
    printf("USAGE ERROR: ./GameLogicLayout <RUN>  <PLAYERS>\n"); 
    printf("Input YES - 1 or NO - 0 for <RUN> and 3 or 4 for <PLAYERS>\n"); 
}

int endgame(char accusation[]) {
   char *murderer_name = murderer_names[murderer];  

    if(murderer_name == accusation) {
	return 1;
    }
    
    return 0;
}

int main(int argc, char *argv[]) {
    

    // Check for improper use errors

    if(argc != 3) {
	use_exception(); 
	return EXIT_FAILURE;
    }
    
    char *p;

    running = strtol(argv[1], &p, 10); 		// Converts <RUN> argv from string to base 10 integer
    players = strtol(argv[2], &p, 10); 		// Converts <PLAYERS> argv from string to base 10 integer
					    
    // Checks if RUN is not set to 0 or 1    

    if(running < 0) { 
	use_exception();
	return EXIT_FAILURE;
    }

    if(running > 1) {
	use_exception();
	return EXIT_FAILURE;
    }

    // Checks if PLAYERS is not set to 3 or 4

    if(players < 3) {
	use_exception();
	return EXIT_FAILURE;
    }
    
    if(players > 4) { 
	use_exception();
	return EXIT_FAILURE;
    }

    // Launches game if no exceptions found 

    launch_game(); 
    	
    bool ban_player[4] = {false, false, false, false};

    // Starts game loop

    while(running) { 

	// Initialize dice roll and dice roll button

	int roll_button = LO;
	int accuse_button = LO;

	int dice_roll = 0;
	int accusing_player = 0;
	char accused_player_name[32];

	int turn = 0;

	// Checks whether the max number of rounds has been played 
	
	if(game_runtime != MAX_RUNTIME) {
	    
	    game_runtime = game_runtime + 1;     	

	    // TODO: fix turns breaking with incorrect input 
	    while(turn < players) {
		
		if(ban_player[turn] != true){

		    char *player_name = player_names[turn];
	    
		    printf("%s's Turn:\n", player_name);			
		    printf("Roll dice? (1 - YES, 0 - NO)\n");			
		    scanf("%d", &roll_button);

		    // Checks whether a dice roll is needed

		    if(roll_button == HI) {

			dice_roll = rand() % 7;			// NOTE: modulo is not actually needed as part of the ISA
			printf("DICE = %d\n", dice_roll);		// Prints randomly selected number between 0-6 
								
		    }
		    
		    // Checks whether no dice roll is needed

		    else if(roll_button == LO) {		
	 
			printf("Accuse? (1 - YES, 0 - NO)\n");			
			scanf("%d", &accuse_button);
		
			// Checks whether a player is being accused

			if(accuse_button == HI) {
			    
			    // TODO: End game once the accused player has been correctly guessed
			    // TODO: OR if no player guesses correctly (or no player is left), killer wins and game ends. 

			    printf("Who is being accused? (Enter Name)\n");
			    scanf("%s", accused_player_name);
	    
			    printf("%s! Well, OK...\n", accused_player_name);

			    int win_or_lose = endgame(accused_player_name);

			    if(win_or_lose == WIN) { 
				printf("Player %s wins!\n", player_name);
				game_runtime = MAX_RUNTIME;
				break;
			    }

			    if(win_or_lose == LOSE) { 
				printf("Player %s loses!\n", player_name);
				ban_player[turn] = true; 
			    }

			}

		    }

		    // Checks for error and resets round if needed
		    
		    else {					
			printf("Incorrect Input. Input 1 for HI or 0 for LO.\n");
			turn = turn - 1;
			break;
		    }

		}

		turn = turn + 1;

	    }
	}

	else {

	    running = false;

	}

    }
    
    printf("Killer = %s\n", murderer_names[murderer]);
    printf("Game Ran Successfully\n");
    return EXIT_SUCCESS;
     
}
