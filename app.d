import std.stdio;
import std.random;

/**
 * A list of all the possible generatable words
 */
static string[] vocab = ["apple", "bacon", "doughnut", "smart", "intelligent", "excellent", "school", "clock", "table"];

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
	public string word;
	public int points;
	public int amtWrong;
	public int amtRight;
	
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
}

/**
 * Main entry point and beginning of program
 */
static void main() {
	//TODO read dictionary file and add words to vocab
	HangManBoard game = new HangManBoard();
	writeln(game.word);
}

/**
 * Clears console by printing a bunch of empty lines
 */
static void clearLog() {
	for(int i = 0; i < 100; i++){
		writeln();
	}
}
