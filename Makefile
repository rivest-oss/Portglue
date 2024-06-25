RM			= rm -f
MKDIR		= mkdir -p

CXX			= g++
CXXFLAGS	= -std=c++17 -Wall -Wextra -Wpedantic
CXXFLAGS	+= `pkg-config openssl --cflags`
LDFLAGS		= `pkg-config openssl --libs`

CPPCHECK	= cppcheck
CLANGXX		= clang++
VALGRIND	= valgrind

ifeq ($(origin DEBUG), environment)
	CXXFLAGS += -Og -g -DGLUEBALL_DEBUG
else
	CXXFLAGS += -O2
endif

all: glueball

clean:
	$(RM) ./out/glueball

check:
	$(CPPCHECK) --language=c++ --std=c++17 ./src/main.c++
	$(CLANGXX) --analyze -Xclang -analyzer-output=html $(CXXFLAGS) \
		-o ./out/analysis \
		./src/main.c++ \
		$(LDFLAGS)

glueball:
	$(MKDIR) ./out/
	$(CXX) $(CXXFLAGS) -o ./out/glueball ./src/main.c++ $(LDFLAGS)

test:
	$(VALGRIND) \
		--leak-check=full \
		--show-leak-kinds=all \
		--track-origins=yes \
		./out/glueball