#include <SFML/Window.hpp>
#include <SFML/Graphics.hpp>
#include <iostream>
using namespace std;

int main() {
    sf::ContextSettings settings;
    settings.antialiasingLevel = 8;

    sf::RenderWindow window(sf::VideoMode(800, 600), "My Window", sf::Style::Default, settings);

    window.setVerticalSyncEnabled(true); // call it once, after creating the window
    window.setFramerateLimit(60); // call it once, after creating the window
    window.setActive();
    window.setKeyRepeatEnabled(false);

    sf::Clock clock;

    while (window.isOpen()) {
        sf::Event event;
        while (window.pollEvent(event)) {
            switch (event.type) {
                case sf::Event::KeyPressed:
                    switch (event.key.code) {
                        case sf::Keyboard::Escape:
                            window.close();
                            break;
                    }
                    break;
                case sf::Event::KeyReleased:
                    break;
                case sf::Event::Closed:
                    break;
                case sf::Event::Resized:
                    sf::FloatRect visibleArea(0, 0, event.size.width, event.size.height);
                    window.setView(sf::View(visibleArea));
                    break;
            }
        }

        sf::Time delta = clock.restart();

        // TODO: update
        
        window.clear(sf::Color::Black);

        // TODO: draw

        window.display();
    }

    return 0;
}

