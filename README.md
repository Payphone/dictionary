# Dictionary
A StumpWM module for looking up definitions in the Merriam-Webster dictionary.

## Installation
Clone the repository and move it to your StumpWM modules folder. The modules
folder has changed several times throughout the StumpWM releases, so the best
way to find it is to eval `*modules-dir*` in StumpWM (C-t :).
```
git clone https://github.com/Payphone/dictionary.git
mv dictionary ~/.stumpwm.d/modules/
```
Now update your .stumpwmrc file to include the following (change the [YOUR KEY]
portion to reflect your API key):
```
(load-module "dictionary")
(setf dictionary:*api-key* "[YOUR KEY]")
(define-key *root-map* (kbd "d") "get-definition")
```
You can change the key binding to whatever suites your tastes.
