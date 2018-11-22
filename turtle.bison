%{
  #include <iostream>
  #define pi 3.14159265359
  #include <math.h>
  #include <SDL2/SDL.h>
  #include <stdexcept>
  using namespace std;
  int yyerror(char *s) { printf("%s\n", s); }
  class Turtle{
    public: 
    Turtle();
    ~Turtle();
    void forward(double);
    void left(double);
    void right(double);
    void clear();
    void flush();
    private:
    SDL_Window *window;
    SDL_Renderer *renderer;
    double x = 1200/2;
    double y = 720/2;
    double a = 0;
    };
    Turtle t ;
%}
%type <valeur> expression;
%token  FORWARD;
%token  RIGHT;
%token  LEFT;

%token <valeur> NUMBER
%token <nom> IDENTIFIER
%token REPEAT

%left '+' '-'     /* associativité à gauche */
%left '*' '/'     /* associativité à gauche */

%%
ligne : ligne instruction '\n' 
      |    /* Epsilon */
      ;
instruction : expression { }
            | REPEAT '(' expression ')' expression { for (int i =0; i<$3; i++) cout << $5 << endl;}
            | IDENTIFIER '=' expression  {
                         cout << "Affectation de " << $3 << " à " << $1 << endl;}
            | FORWARD '('expression ')'      {cout<< "En avant"<<$3<<endl; t.forward($3);}
            | LEFT    '('expression ')'      {cout<< "gauche"<<$3<<endl; t.left($3);}
            | RIGHT   '('expression')'       {cout<< "droite"<<$3<<endl; t.right($3);}             
            |   /* Ligne vide*/
            ;
expression: expression '+' expression     {cout<<"plus"; }
          | expression '-' expression     {cout<<"moins";}
          | expression '*' expression     { cout<<"fois";}
          | expression '/' expression     { cout<<"diviser";}
          | '(' expression ')'            { }
          | NUMBER                        { cout<<"Number";}
          | IDENTIFIER                    {cout<<"indentifier";}
          ;
%%

  Turtle::Turtle(){
        if(SDL_Init(SDL_INIT_VIDEO) != 0){
         throw std::runtime_error("SDL_INIT_VIDEO");
        }
        
        SDL_CreateWindowAndRenderer(1200,700,SDL_WINDOW_OPENGL | SDL_WINDOW_BORDERLESS,&window,&renderer);
        SDL_SetWindowPosition(window,65,126);
    }
    Turtle::~Turtle(){
        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(window);
        SDL_Quit(); 
           }
    void Turtle::forward(double value){
        auto nx = x + value * cos(a/360.0 * 2.0 * pi);
        auto ny = y + value * sin(a/360.0 * 2.0 * pi);
        SDL_RenderDrawLine(renderer,x,y,nx,ny);
        x = nx;
        y = ny;
    }
    void Turtle::left(double value){
        a-=value;
    }
    void Turtle::right(double value){
        a+= value;
    };
    void Turtle::clear(){
        SDL_SetRenderDrawColor(renderer, 255,255,255,255);
        SDL_RenderClear(renderer);
        SDL_SetRenderDrawColor(renderer,0,0,0,255);
    }
    void Turtle::flush(){
        SDL_RenderPresent(renderer);
    }

int main() {
    yyin = stdin;
}