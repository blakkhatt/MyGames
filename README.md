# Game Collection

A collection of games and visualizations built with Julia and Node.js, featuring fractal battles and classic Snake.

## Projects

### 1. Fractal Battle Game (Julia)

An AI-driven battle between mathematical fractals like Mandelbrot and Julia sets. Fighters have health, defense, and special abilities. The game generates animated MP4 videos of the battles.

#### Features
- Mandelbrot, Julia, and Burning Ship fractals as fighters
- AI agents with strategic decision-making
- Special abilities: Deep Zoom (power boost), Iterate Heal, Burning Burst, Variant Shift
- Defense mechanics reducing damage
- Video generation with real-time fractal animations
- Tournament mode with multiple fighters

#### How to Run
1. Ensure Julia is installed.
2. Activate environment: `julia --project`
3. Run AI battle: `julia --project main.jl` (choose 'a' for AI demo)
4. For video: Generates `battle.mp4` with fractal animations
5. Interactive mode: Choose 'i' for player vs AI battle

#### Files
- `main.jl`: Core game logic, fractal generation, battle simulation
- `Project.toml`: Julia dependencies (Plots, VideoIO, etc.)
- `frames/`: Generated animation frames
- `battle.mp4`: Output video

### 2. Web Server (Node.js)

A localhost web server serving interactive games and visualizations.

#### Features
- Serves HTML pages for games
- RESTful endpoints for fractal images (PNG)
- Supports real-time animations

#### How to Run
1. Install Node.js.
2. Run: `node server.js`
3. Open http://localhost:3000 in browser

#### Files
- `server.js`: HTTP server setup
- `index.html`: Interactive fractal battle with live animations
- `snake.html`: Web-based Snake game

### 3. Snake Game (Node.js)

Classic Snake game playable in browser or console.

#### Web Version Features
- Canvas-based graphics
- Arrow key controls
- Score tracking
- Collision detection

#### Console Version Features
- Text-based display
- Readline input
- Same gameplay

#### How to Run
- Web: Start server (`node server.js`) and visit http://localhost:3000
- Console: `node snake.js` (use arrow keys, q to quit)

#### Files
- `snake.js`: Console Snake game
- `snake.html`: Web Snake game

## Requirements

- Julia 1.10+
- Node.js 14+
- GitHub CLI (for repo management)

## Installation

1. Clone the repo: `git clone https://github.com/blakkhatt/MyGames.git`
2. For Julia: `cd MyGames && julia --project`
3. For Node.js: Ensure Node.js installed

## Usage

- Fractal Battles: `julia --project main.jl`
- Web Games: `node server.js` then http://localhost:3000
- Console Snake: `node snake.js`

## Contributing

Feel free to fork and add more games or features!

## License

MIT License