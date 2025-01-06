# Ping Pong Game

Welcome to the **Ping Pong Game** repository! This project demonstrates the implementation of a classic Ping Pong game using **Verilog** and **C** on the DE10-Lite FPGA development board.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Project Structure](#project-structure)
- [Technologies Used](#technologies-used)
- [Getting Started](#getting-started)
- [Game Modes](#game-modes)
- [Acknowledgments](#acknowledgments)

## Overview

This project is a digital recreation of the classic Ping Pong game, combining hardware design and software programming. The hardware components were written in Verilog/SystemVerilog, and the game logic was implemented in C.

The game supports multiple difficulty levels and utilizes the VGA interface for graphical output, allowing players to engage in a visually immersive experience.

## Features

- **Difficulty Levels**: Choose between Easy, Medium, and Hard modes.
- **Player Win Detection**: Displays when Player 1 or Player 2 wins.
- **Custom VGA Controller**: Displays game graphics on a VGA monitor.
- **DE10-Lite Compatibility**: Designed for the DE10-Lite FPGA board.
- **Interactive Gameplay**: Real-time game controls.

## Project Structure

```
Ping_Pong/
├── .metadata
├── .qsys_edit
├── Easy
├── Hard
├── Medium
├── Lab 62 provided files
├── P1wins
├── P2Wins
├── simulation/modelsim
├── software
├── DE10_LITE.qsf
├── VGA_text_mode_controller_hw.tcl
├── final_project.sv
├── lab62_soc
├── menu
└── output_files
```

## Technologies Used

- **Languages**: Verilog, SystemVerilog, C
- **Tools**: Quartus Prime, ModelSim, GCC
- **Hardware**: DE10-Lite FPGA Board
- **VGA Output**: For graphical display

## Getting Started

### Prerequisites

- DE10-Lite FPGA Development Board
- Quartus Prime Software
- ModelSim for simulation
- VGA-compatible monitor

### Steps to Run the Game

1. Clone the repository:
   ```bash
   git clone https://github.com/syedr3/Ping_Pong.git
   cd Ping_Pong
   ```
2. Open the project in Quartus Prime.
3. Compile the project to generate the bitstream file.
4. Load the bitstream onto the DE10-Lite board.
5. Connect a VGA monitor to the board.
6. Run the software game logic written in C.
7. Enjoy the game!

## Game Modes

- **Easy**: Slower ball movement and forgiving paddle collisions.
- **Medium**: Balanced speed and collision handling.
- **Hard**: Faster ball movement and challenging paddle collisions.

## Acknowledgments

- Inspired by the classic Ping Pong game.
- Lab 62 files provided the foundation for hardware setup.

---

Feel free to explore, play, and modify this project. Happy coding! 🚀
