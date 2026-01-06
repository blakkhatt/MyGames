const readline = require('readline');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

class SnakeGame {
    constructor() {
        this.width = 20;
        this.height = 10;
        this.snake = [{x: 10, y: 5}];
        this.direction = 'right';
        this.food = this.generateFood();
        this.score = 0;
        this.gameOver = false;
    }

    generateFood() {
        let food;
        do {
            food = {
                x: Math.floor(Math.random() * this.width),
                y: Math.floor(Math.random() * this.height)
            };
        } while (this.snake.some(segment => segment.x === food.x && segment.y === food.y));
        return food;
    }

    draw() {
        console.clear();
        for (let y = 0; y < this.height; y++) {
            let line = '';
            for (let x = 0; x < this.width; x++) {
                if (this.snake.some(segment => segment.x === x && segment.y === y)) {
                    line += 'O';
                } else if (this.food.x === x && this.food.y === y) {
                    line += '*';
                } else {
                    line += '.';
                }
            }
            console.log(line);
        }
        console.log(`Score: ${this.score}`);
    }

    update() {
        const head = { ...this.snake[0] };
        switch (this.direction) {
            case 'up': head.y--; break;
            case 'down': head.y++; break;
            case 'left': head.x--; break;
            case 'right': head.x++; break;
        }

        if (head.x < 0 || head.x >= this.width || head.y < 0 || head.y >= this.height ||
            this.snake.some(segment => segment.x === head.x && segment.y === head.y)) {
            this.gameOver = true;
            return;
        }

        this.snake.unshift(head);

        if (head.x === this.food.x && head.y === this.food.y) {
            this.score++;
            this.food = this.generateFood();
        } else {
            this.snake.pop();
        }
    }

    run() {
        rl.input.on('keypress', (str, key) => {
            if (key.name === 'up' && this.direction !== 'down') this.direction = 'up';
            else if (key.name === 'down' && this.direction !== 'up') this.direction = 'down';
            else if (key.name === 'left' && this.direction !== 'right') this.direction = 'left';
            else if (key.name === 'right' && this.direction !== 'left') this.direction = 'right';
            else if (key.name === 'q') process.exit();
        });

        const gameLoop = () => {
            if (!this.gameOver) {
                this.update();
                this.draw();
                setTimeout(gameLoop, 200);
            } else {
                console.log('Game Over! Final Score:', this.score);
                rl.close();
            }
        };
        gameLoop();
    }
}

const game = new SnakeGame();
console.log('Snake Game! Use arrow keys to move, q to quit.');
game.run();