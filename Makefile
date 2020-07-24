##
## EPITECH PROJECT, 2019
## Makefile
## File description:
## Makefile
##

NAME	=	groundhog

all:	$(NAME)

$(NAME):
	cp groundhog.rb $(NAME)
	chmod +x $(NAME)
clean:
	rm -f $(NAME)

fclean:	clean

re:	fclean all

.PHONY:	fclean all clean re
