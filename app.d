import std.stdio;
import std.random;
import std.string;
import std.array;
import std.file;
import std.conv;
import std.regex;
import std.algorithm.searching;
import std.algorithm.mutation;

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
static const int wrongToEndGame = 7;	

/**
 * Main entry point and beginning of program
 */
static void main() {
	File file = File("E:\\Documents\\Eclipse D Workspace\\Hangman\\src\\listOfWords.txt", "r");
	vocab = file.byLineCopy().array();
	file.close();
	getNewWord();
	clearLog();
	while(amtWrong < wrongToEndGame){
		writeln(gameString());
		stdout.flush();
		string input;
		do{
			input = strip(readln()).toLower();
		}while(input == "" || guessed.canFind(input));
		clearLog();
		if(interpretInput(input)){
			writeln("Good job! You completed your word \"" ~ word ~ "\"! Press enter to continue...");
			points += 5;
			getNewWord();
			stdout.flush();
			readln();
			clearLog();
		}
	}
	clearLog();
	writeln(gameString());
	writeln("You lost on \"" ~ word ~ "\". Press enter to continue...");
	stdout.flush();
	readln();
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
	int index = uniform(0, vocab.length);
	word = vocab[index];
	remove(vocab, index);
	displayableWord = null;
	guessed = null;
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
 * Returns whether the word was completed
 */
static bool interpretInput(string toInterpret){
	guessed ~= toInterpret;
	string[] splitString = split(word, toInterpret);
	if(splitString.length - 1 == 0){
		incrementWrong();
		return false;
	}
	for(int i = 0; i < word.length - toInterpret.length + 1; i++){
		bool startsAtThisIndex = true;
		for(int j = 0; j < toInterpret.length; j++){
			if(word[i + j] != toInterpret[j]){
				startsAtThisIndex = false;
				break;
			}
		}
		if(startsAtThisIndex){
			for(int j = 0; j < toInterpret.length; j++){
				if(displayableWord[i + j] == "_"){
					amtRight++;
					displayableWord[i + j] = to!string(toInterpret[j]);
					points += (canFind("aeiou", toInterpret[j]))? 1 : 3;
				}
			}
		}
	}
	return !canFind(displayableWord, "_");
}
