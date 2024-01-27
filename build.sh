#!/bin/sh

# On utilise -Q pour s'assurer que Emacs ne load pas nos paramètres personnels.
# Faut vraiment pas que tout ça dépende de notre config, en gros. 
emacs -Q --script build-site.el
