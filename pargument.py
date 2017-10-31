# -*- coding:UTF-8 -*-
import random

print("let's play a game, i'm thinking a number between 1-20", "take a guess ")
secret = random.randint(1,20)

guess = int(input("tape a number"))
n=1
while guess!=secret:
    if n > 3:
        print("You are a fool, Oh my god! You guessed %d times" %n)
        break
    if guess < secret:
        print("too small\n", "again")
        n=n+1
        guess=int(input("tape a number\n"))
    elif guess > secret:
        print("too big\n", "again")
        n=n+1
        guess=int(input("tape a number\n"))
    if guess == secret:
        print("you are right\n" + "you guess for " + str(n) + " times")
        break



