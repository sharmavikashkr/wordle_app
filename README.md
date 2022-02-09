# A Wordle App

A wordle app in flutter to imitate the awesome [Wordle](https://www.powerlanguage.co.uk/wordle/)

## What's different?

* While Wordle brings the entire list of words with it when the page is loaded (YES!), I have created an [API](https://github.com/sharmavikashkr/wordle-function) to verify the words against. This API takes and verifies a word against the word of the day (stored in a DB).
* Wordle has a list of legit words and it allows you to input a word only from that list. On the contrary, I query a [Free Dictionary API](https://dictionaryapi.dev/) and validate if an input word is a legit English word.

## What's inside?

* <ins>The word_field component</ins>
This component creates an input widget which accepts a 5 letter word in 5 boxes (1 for each letter). This is similar to creating an OTP field.
* <ins>The home component</ins>
This component builds a scaffold and puts together a page to accept 6 attempts for words.
* <ins>The states</ins>
I am maintaining 5 state variables in the home component:
  * <strong>_attempts</strong>: holds the number of attempts executed so far.
  * <strong>_wordColors</strong>: holds a list of 6 color codes (like ‘bggyb’; returned from the API). Each color code is passed on to the respective word_field component to fill the letter backgrounds accordingly.
  * <strong>_wordsEnabled</strong>: holds a list of 6 bools to identify which word_field is accepting input. Other word_fields as disabled.
  * <strong>gameover</strong>: holds a bool to store if the game is over.
  * <strong>shareMessage</strong>: is built if the word of the day is successfully guessed and the game is over.
* <ins>The _checkWord handler</ins> (inside home component)
This handler calls the wordle-api, gets the color code, and updates the components accordingly.
* <ins>The shareMessage builder</ins> (inside home component)
This piece takes care of creating the share message if the game is successfully won.

## Possible Future works

* Actual sharing of <strong>shareMessage</strong> to social handles.
* The flip/shake animations of the letter/word widgets respectively.
* Make it scalable enough to accept words in variable lengths (4 through 8?)