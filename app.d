import std.stdio;
import std.random;

static string[] vocab = ["apple", "bacon", "doughnut", "smart", "intelligent", "excellent"];

void main() {
	//TODO read dictionary file and add words to vocab
	string word = vocab[uniform(0, vocab.length)];
	writeln(word);
}