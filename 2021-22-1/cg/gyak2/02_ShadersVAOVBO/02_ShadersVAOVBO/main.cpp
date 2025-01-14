// GLEW
#include <GL/glew.h>

// SDL
#include <SDL.h>
#include <SDL_opengl.h>

#include <iostream>
#include <sstream>

#include "MyApp.h"

void exitProgram()
{
	SDL_Quit();

	std::cout << "Kil�p�shez nyomj meg egy billenty�t..." << std::endl;
	std::cin.get();
}

int main( int argc, char* args[] )
{
	// �ll�tsuk be, hogy kil�p�s el�tt h�vja meg a rendszer az exitProgram() f�ggv�nyt - K�rd�s: mi lenne en�lk�l?
	atexit([] {
			std::cout << "Press a key to exit the application..." << std::endl;
			std::cin.get();
		});

	//
	// 1. l�p�s: inicializ�ljuk az SDL-t
	//

	// a grafikus alrendszert kapcsoljuk csak be, ha gond van, akkor jelezz�k �s l�pj�n ki
	if ( SDL_Init( SDL_INIT_VIDEO ) == -1 )
	{
		// irjuk ki a hibat es terminaljon a program
		std::cout << "[SDL initialization] Error during the SDL initialization: " << SDL_GetError() << std::endl;
		return 1;
	}
			
	//
	// 2. l�p�s: �ll�tsuk be az OpenGL-es ig�nyeinket, hozzuk l�tre az ablakunkat, ind�tsuk el az OpenGL-t
	//

	// 2a: OpenGL ind�t�s�nak konfigur�l�sa, ezt az ablak l�trehoz�sa el�tt kell megtenni!

	// be�ll�thatjuk azt, hogy pontosan milyen OpenGL context-et szeretn�nk l�trehozni - ha nem tessz�k, akkor
	// automatikusan a legmagasabb el�rhet� verzi�j�t kapjuk
    //SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
    //SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 2);

    SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);

	// �ll�tsuk be, hogy h�ny biten szeretn�nk t�rolni a piros, z�ld, k�k �s �tl�tszatlans�gi inform�ci�kat pixelenk�nt
    SDL_GL_SetAttribute(SDL_GL_BUFFER_SIZE,         32);
    SDL_GL_SetAttribute(SDL_GL_RED_SIZE,            8);
    SDL_GL_SetAttribute(SDL_GL_GREEN_SIZE,          8);
    SDL_GL_SetAttribute(SDL_GL_BLUE_SIZE,           8);
    SDL_GL_SetAttribute(SDL_GL_ALPHA_SIZE,          8);
	// duplapufferel�s
	SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER,		1);
	// m�lys�gi puffer h�ny bites legyen
    SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE,          24);

	// antialiasing - ha kell
	//SDL_GL_SetAttribute(SDL_GL_MULTISAMPLEBUFFERS,  1);
	//SDL_GL_SetAttribute(SDL_GL_MULTISAMPLESAMPLES,  2);

	// hozzuk l�tre az ablakunkat
	SDL_Window *win = nullptr;
    win = SDL_CreateWindow( "Hello SDL&OpenGL!",		// az ablak fejl�ce
							100,						// az ablak bal-fels� sark�nak kezdeti X koordin�t�ja
							100,						// az ablak bal-fels� sark�nak kezdeti Y koordin�t�ja
							800,						// ablak sz�less�ge
							600,						// �s magass�ga
							SDL_WINDOW_OPENGL | SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE);			// megjelen�t�si tulajdons�gok


	// ha nem siker�lt l�trehozni az ablakot, akkor �rjuk ki a hib�t, amit kaptunk �s l�pj�nk ki
    if (win == nullptr)
	{
		std::cout << "[Window creation] Error during the creation of an SDL window: " << SDL_GetError() << std::endl;
        return 1;
    }

	//
	// 3. l�p�s: hozzunk l�tre az OpenGL context-et - ezen kereszt�l fogunk rajzolni
	//

	SDL_GLContext	context	= SDL_GL_CreateContext(win);
    if (context == nullptr)
	{
		std::cout << "[OGL context creation] Error during the creation of the OGL context: " << SDL_GetError() << std::endl;
        return 1;
    }	

	// megjelen�t�s: v�rjuk be a vsync-et
	SDL_GL_SetSwapInterval(1);

	// ind�tsuk el a GLEW-t
	GLenum error = glewInit();
	if ( error != GLEW_OK )
	{
		std::cout << "[GLEW] Error during the initialization of glew:" << std::endl;
		return 1;
	}

	// k�rdezz�k le az OpenGL verzi�t
	int glVersion[2] = {-1, -1}; 
	glGetIntegerv(GL_MAJOR_VERSION, &glVersion[0]); 
	glGetIntegerv(GL_MINOR_VERSION, &glVersion[1]); 
	std::cout << "Running OpenGL " << glVersion[0] << "." << glVersion[1] << std::endl;

	if ( glVersion[0] == -1 && glVersion[1] == -1 )
	{
		SDL_GL_DeleteContext(context);
		SDL_DestroyWindow( win );

		std::cout << "[OGL context creation] Error during the inialization of the OGL context! Maybe one of the SDL_GL_SetAttribute(...) calls is erroneous." << std::endl;

		return 1;
	}

	std::stringstream window_title;
	window_title << "OpenGL " << glVersion[0] << "." << glVersion[1];
	SDL_SetWindowTitle(win, window_title.str().c_str());

	//
	// 3. l�p�s: ind�tsuk el a f� �zenetfeldolgoz� ciklust
	// 

	// v�get kell-e �rjen a program fut�sa?
	bool quit = false;
	// feldolgozand� �zenet ide ker�l
	SDL_Event ev;
	
	// alkalmazas p�ld�nya
	CMyApp app;
	if (!app.Init())
	{
		SDL_GL_DeleteContext(context);
		SDL_DestroyWindow(win);
		std::cout << "[app.Init] Error during the initialization of the application!" << std::endl;
		return 1;
	}

	while (!quit)
	{
		// am�g van feldolgozand� �zenet dolgozzuk fel mindet:
		while ( SDL_PollEvent(&ev) )
		{
			switch (ev.type)
			{
			case SDL_QUIT:
				quit = true;
				break;
			case SDL_KEYDOWN:
				if ( ev.key.keysym.sym == SDLK_ESCAPE )
					quit = true;
				app.KeyboardDown(ev.key);
				break;
			case SDL_KEYUP:
				app.KeyboardUp(ev.key);
				break;
			case SDL_MOUSEBUTTONDOWN:
				app.MouseDown(ev.button);
				break;
			case SDL_MOUSEBUTTONUP:
				app.MouseUp(ev.button);
				break;
			case SDL_MOUSEWHEEL:
				app.MouseWheel(ev.wheel);
				break;
			case SDL_MOUSEMOTION:
				app.MouseMove(ev.motion);
				break;
			case SDL_WINDOWEVENT:
				if ( ev.window.event == SDL_WINDOWEVENT_SIZE_CHANGED )
				{
					app.Resize(ev.window.data1, ev.window.data2);
				}
				break;
			}
		}

		app.Update();
		app.Render();

		SDL_GL_SwapWindow(win);
	}


	//
	// 4. l�p�s: l�pj�nk ki
	// 

	// takar�tson el maga ut�n az objektumunk
	app.Clean();

	SDL_GL_DeleteContext(context);
	SDL_DestroyWindow( win );

	return 0;
}