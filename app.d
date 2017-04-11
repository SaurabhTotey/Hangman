import std.stdio;
import std.random;
import std.string;
import std.array;
import std.file;
import std.conv;

/**
 * A list of all the possible generatable words
 */
static string[] vocab;

/**
 * An unecessary class (I am just using this to practice OO) to handle game stats
 * All of this could be done statically, as this is only ever instantiated once
 */
public class HangManBoard {
	
	/**
	 * Instance data for a HangManBoard class
	 * <br><strong>word</strong>: the word that the user is currently trying to guess
	 * <br><strong>points</strong>: the amount of points the user has acculmulated from correct guesses
	 * <br><strong>amtWrong</strong>: how many times the user has guessed a wrong letter
	 * <br><strong>amtRight</strong>: how many times the user has guessed a right letter
	 */
	private string word;
	private string[] guessed;
	private int points;
	private int amtWrong;
	private int amtRight;
	private string[] board = [
		"      _______  ",
		"     |/      | ",
		"     |         ",
		"     |         ",
		"     |         ",
		"     |         ",
		"     |         ",
		" ____|___      "
		];
	
	/**
	 * Constructor for a HangManBoard object
	 * Automatically gives itself a word
	 */
	public this(){
		this.getNewWord();
	}
	
	/**
	 * Generates a random new word and sets the current word as the new word
	 */
	public void getNewWord(){
		this.word  = vocab[uniform(0, vocab.length)];
	}
	
	/**
	 * Returns a string representation of the board
	 */
	override public string toString(){
		string boardAsString = format(
			board[0] ~ "\n" ~
			board[1] ~ "\tYou have %s points\n" ~
			board[2] ~ "\tYour correct/incorrect percentage is %s\n" ~
			board[3] ~ "\n" ~
			board[4] ~ "\n" ~
			board[5] ~ "\n" ~
			board[6] ~ "\n" ~
			board[7] ~ "\tSo far, you have guessed the letters", this.points, (this.amtRight + this.amtWrong == 0)?  "?" : to!string(100 * this.amtRight / (this.amtRight + this.amtWrong)) ~ "%");
		foreach(string individualGuess ; this.guessed){
			boardAsString ~= individualGuess ~ ", ";
		}
		boardAsString ~= "\b\b";
		return boardAsString;
	}
	
	/**
	 * Adds one more to the amtWrong variable and changes the board accordingly
	 */
	public void incrementWrong(){
		amtWrong++;
		if(amtWrong > 6){
			this.board[5] = "     |      / \\";
		}else if(amtWrong > 5){
			this.board[5] = "     |      /  ";
		}else if(amtWrong > 4){
			this.board[4]  ="     |       | ";
		}else if(amtWrong > 3){
			this.board[3] = "     |      \\|/";
		}else if(amtWrong > 2){
			this.board[3] = "     |      \\| ";
		}else if(amtWrong > 1){
			this.board[3] = "     |       | ";
		}else if(amtWrong > 0){
			this.board[2] = "     |      (_)";
		}
	}
}

/**
 * Main entry point and beginning of program
 */
static void main() {
	File file = File("E:\\Documents\\Eclipse D Workspace\\Hangman\\src\\listOfWords.txt", "r");
	vocab = file.byLineCopy().array();
	file.close();
	HangManBoard game = new HangManBoard();
	writeln(game);
}

/**
 * Clears console by printing a bunch of empty lines
 */
static void clearLog() {
	for(int i = 0; i < 100; i++){
		writeln();
	}
}
