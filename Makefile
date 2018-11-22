all:
	rm turtle turtle.flex.cpp turtle.bison.cpp turtle.bison.hpp
	flex -o turtle.flex.cpp turtle.flex
	bison -d turtle.bison -o turtle.bison.cpp
	g++ -o turtle turtle.flex.cpp turtle.bison.cpp -w -lSDL2
	./turtle