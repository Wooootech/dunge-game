#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>	// in case you want abs()

#define MAX_XY	128

// globals
int u_x=1, u_y=1;	// user x,y location on grid
int g_x=1, g_y=1;	// macguffin x,y location on grid (g for "goal")
FILE *fp;
char layout[MAX_XY][MAX_XY];
int max_x, max_y;
int Radius;

// Radius values:
#define FULL	100
#define	EXHARD	1
#define	VHARD	2
#define	HARD	3
#define	MEDIUM	4
#define	EASY	5
#define	VEASY	6
#define	EXEASY	7

// declaration of function prototypes
void save_state();
void refresh_screen(int);
void init(int, char **);
void leave_game(char *);
void do_move(char);

// movement controls -- feel free to redefine
#define MOV_NW	'7'
#define MOV_N	'8'
#define MOV_NE	'9'
#define MOV_E	'6'
#define MOV_SE	'3'
#define MOV_S	'2'
#define MOV_SW	'1'
#define MOV_W	'4'
#define MOV_0	'5'
#define AMOV_NW	'q'
#define AMOV_N	'w'
#define AMOV_NE	'e'
#define AMOV_E	'd'
#define AMOV_SE	'c'
#define AMOV_S	'x'
#define AMOV_SW	'z'
#define AMOV_W	'a'
#define AMOV_0	's'
#define EXIT	'.'
#define SAVE	'S'

// symbols in the input .dat file
#define OPEN_DOOR	'%'
#define HIDDEN_DOOR	'*'
#define LOCKED_DOOR '+'
#define WALL		'#'
#define FLOOR		' '
#define MacGuffin	'$'

int main(int argc, char *argv[])
{
	char c;

	init(argc, argv);

	refresh_screen(Radius);

	while (1) {
		switch (c = getchar()) {

			case MOV_N :	// UP
			case MOV_S :	// DOWN
			case MOV_E :	// RIGHT
			case MOV_W :	// LEFT
			case MOV_NW :	// L+U
			case MOV_SW :	// L+D
			case MOV_NE :	// R+U
			case MOV_SE :	// R+D
			case MOV_0 :	// wait
			case AMOV_N :	// UP
			case AMOV_S :	// DOWN
			case AMOV_E :	// RIGHT
			case AMOV_W :	// LEFT
			case AMOV_NW :	// L+U
			case AMOV_SW :	// L+D
			case AMOV_NE :	// R+U
			case AMOV_SE :	// R+D
			case AMOV_0 :	// wait
				do_move(c);
				refresh_screen(Radius);
			break;

			case 'h' :	// HINT
				refresh_screen(FULL);
			break;

			case SAVE :	// save - do not exit
				save_state();
				refresh_screen(Radius);
				printf("Stated saved.\r\f");
			break;

			case EXIT :	// exit - do not save
				leave_game("\nGood Bye.\n");
			break;

			case '\n' : // newline -- ignore
				// do nothing
			break;

			default:
				printf("Error: Unrecognized input [%c]\r\f", c);
			break;
		}
	}
}

void do_move(char c) 
{
	// handle movement:
	// handle possible collisions:
	// FLOOR, OPEN_DOOR, HIDDEN_DOOR - safe to move there
	// WALL, LOCKED_DOOR - don't move there
	// MacGuffin - the goal; exit
	// anything else (default) - print error
}

void save_state() 
{
	// same as last time
}

void refresh_screen(int radius)
{
	int x, y;

	int x_radius = radius;
	int y_radius = radius/2 + (radius % 2);

	// print out the layout within the x/y radius of the user
	// FLOOR, WALL, LOCKED_DOOR, MacGuffin - print as-is
	// OPEN_DOOR - print as LOCKED_DOOR
	// HIDDEN_DOOR - print as WALL
}

void init(int argc, char *argv[])
{
	char buf[MAX_XY];
	int x, y;

	if (argc < 2) {
		printf("usage: %s <map file> {easy|medium|hard}\n", argv[0]);
		exit(0);
	}

	if ((fp = fopen(argv[1], "r+")) == (FILE *)NULL) {
		printf("error: cannot open game file %s for reading\n", argv[1]);
		exit(0);
	}
	if (fscanf(fp, "%d,%d\n", &u_x, &u_y) < 2) {
		printf("error: file %s has incorrect header format\n", argv[1]);
		exit(0);
	}
	fgets(buf, MAX_XY, fp);	// skip second line

	// init the array -- this will show you how to use the 2D array
	for (y=0; y<MAX_XY; y++) {
		if (fgets(buf, MAX_XY, fp) == (char *)NULL) {
			max_y = y;
			break;	
		}
		for (x=0; x<MAX_XY; x++) {
			layout[x][y] = buf[x];
			if (buf[x] == '\0') {
				max_x = x-1;
				break;	// go to next row/line/Y
			}
		}
	}

	fprintf(stderr, "Init: Got user=[%d,%d], floorplan=%dx%d\n", u_x, u_y, max_x, max_y);

	Radius = MEDIUM;
	if (argc > 2) {
		if (strcmp(argv[2], "exeasy") == 0) {
			Radius = EXEASY;
		} else if (strcmp(argv[2], "veasy") == 0) {
			Radius = VEASY;
		} else if (strcmp(argv[2], "easy") == 0) {
			Radius = EASY;
		} else if (strcmp(argv[2], "medium") == 0) {
			Radius = MEDIUM;
		} else if (strcmp(argv[2], "hard") == 0) {
			Radius = HARD;
		} else if (strcmp(argv[2], "vhard") == 0) {
			Radius = VHARD;
		} else if (strcmp(argv[2], "exhard") == 0) {
			Radius = EXHARD;
		}
	}

	system ("/bin/stty raw");
}

void leave_game(char *msg)
{
	fclose(fp);
	system ("/bin/stty cooked");
	printf("%s", msg);
	exit(0);
}
