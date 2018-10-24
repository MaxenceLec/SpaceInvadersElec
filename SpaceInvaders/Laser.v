module Laser (
  input clk,
  input reset,
  input enable,
  input fire,
  input killingAlien,
  input [9:0] gunPosition,
  input [9:0] hPos,
  input [9:0] vPos,

  output [9:0] xLaser,
  output [9:0] yLaser,
  output [2:0] colorLaser,
  );

parameter BACKGROUND = 0 ; // Background color code
parameter LASER = 6 ; // Laser color code
parameter RADIUS = 4 ;

parameter SCREEN_WIDTH = 640 ;
parameter SCREEN_HEIGHT = 480 ;
parameter SHIP_WIDTH = 60 ; // Width of the ship
parameter SHIP_HEIGHT = 30 ; // Height of the ship
parameter V_OFFSET = 10 ; // Number of pixels between bottom of the screen and ship
parameter STEP_MOTION = 1 ; // Number of pixels of vertical laser motion

reg laserAlive;
assign vgaInLaser = (hPos - xLaser) * (hPos - xLaser) + (vPos - yLaser) * (vPos - yLaser) <= RADIUS * RADIUS;

  always @ (posedge clk) begin
  if (reset) begin
    laserAlive <= 0;
  end

  else if (enable) begin

    // LASER ALIVE
    if (laserAlive) begin
      if (killingAlien)
        // we destroy the laser
        laserAlive <= 0;

      else begin
        if (yLaser > 0)
          // update laser position
          yLaser <= yLaser - STEP_MOTION;
        else
          // laser out of screen, so we destroy it
          laserAlive <= 0;
      end
    end

    // LASER NOT ALIVE
    else begin
      if (fire)
        // fire laser
        laserAlive <= 1;
    end

    // HANDLE COLOR
    if (laserAlive & vgaInLaser) 
      colorLaser = LASER
    else
      colorLaser = BACKGROUND

  end
end


// fire the laser or hide it
always @ (laserAlive) begin
  if (laserAlive) begin
    // put the laser at start position
    xLaser <= gunPosition;
    yLaser <= SCREEN_HEIGHT - V_OFFSET - SHIP_HEIGHT - RADIUS;
  end else begin
    // put the laser at the right bottom of the screen
    xLaser <= SCREEN_WIDTH - 1;
    yLaser <= SCREEN_HEIGHT - 1;
  end
end


endmodule // Laser
