import std.stdio;
import std.random;
import std.string;
import std.array;
import std.file;
import std.conv;
import std.regex;
import std.algorithm.searching;

/**
 * A list of all of the needed data throughout the game
 */
static string[] vocab;
static string word;
static string[] displayableWord;
static string[] guessed;
static int points;
static int amtWrong;
static int amtRight;
static string[] board = [
	"      _______  ",
	"     |/      | ",
	"     |         ",
	"     |         ",
	"     |         ",
	"     |         ",
	"     |         ",
	" ____|___      "
	];
immutable static int wrongToEndGame = 7;	

/**
 * Main entry point and beginning of program
 */
static void main() {
	File file = File("E:\\Documents\\Eclipse D Workspace\\Hangman\\src\\listOfWords.txt", "r");
	vocab = file.byLineCopy().array();
	file.close();
	getNewWord();
	writeln(gameString());
	while(amtWrong < wrongToEndGame){
		stdout.flush();
		string input = strip(stdin.readln());
		do{
			input = strip(stdin.readln());
		}while(input == "");
		clearLog();
		interpretInput(input);
		writeln(gameString());
	}
}

/**
 * Clears console by printing a bunch of empty lines
 */
static void clearLog() {
	for(int i = 0; i < 100; i++){
		writeln();
	}
}

/**
 * Generates a random new word and sets the current word as the new word
 */
static void getNewWord(){
	word = vocab[uniform(0, vocab.length)];
	displayableWord = null;
	for(int i = 0; i < word.length; i++){
		displayableWord ~= "_";
	}
}

/**
 * Returns a string representation of the board
 */
static string gameString(){
	string boardAsString = format(
		board[0] ~ "\n" ~
		board[1] ~ "\tYou have %s points\n" ~
		board[2] ~ "\tYour correct/incorrect percentage is %s\n" ~
		board[3] ~ "\n" ~
		board[4] ~ "\n" ~
		board[5] ~ "\n" ~
		board[6] ~ "\n" ~
		board[7] ~ "\tSo far, you have guessed the letters ", points, (amtRight + amtWrong == 0)?  "?" : to!string(100 * amtRight / (amtRight + amtWrong)) ~ "%");
	foreach(string individualGuess ; guessed){
		boardAsString ~= (individualGuess == guessed[guessed.length - 1])? individualGuess : individualGuess ~ ", ";
	}
	boardAsString ~= "\n\n";
	foreach(string wordProgressChar ; displayableWord){
		boardAsString ~= " " ~ wordProgressChar;
	}
	return boardAsString;
}

/**
 * Adds one more to the amtWrong variable and changes the board accordingly
 */
static void incrementWrong(){
	amtWrong++;
	points -= 2;
	if(amtWrong > 6){
		board[5] = "     |      / \\";
	}else if(amtWrong > 5){
		board[5] = "     |      /  ";
	}else if(amtWrong > 4){
		board[4]  ="     |       | ";
	}else if(amtWrong > 3){
		board[3] = "     |      \\|/";
	}else if(amtWrong > 2){
		board[3] = "     |      \\| ";
	}else if(amtWrong > 1){
		board[3] = "     |       | ";
	}else if(amtWrong > 0){
		board[2] = "     |      (_)";
	}
}

/**
 * Interprets whatever is passed to it and game is updated accordingly
 */
static void interpretInput(string toInterpret){
	guessed ~= toInterpret;
	string[] splitString = split(word, toInterpret);
	int amtInString = splitString.length - 1;
	if(amtInString == 0){
		incrementWrong();
		return;
	}
	int ptsToAdd;
	for(int i = 0; i < toInterpret.length; i++){
		char character = toInterpret[i];
		ptsToAdd += (canFind("aeiou", character))? 1 : 3;
		amtRight++;
	}
	points += amtInString * ptsToAdd;
	foreach(string stillExists ; splitString){
		for(int i = 0; i < toInterpret.length; i++){
			displayableWord[stillExists.length + i] = to!string(toInterpret[i]);
		}
	}
}
