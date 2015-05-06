program ExampleThreshold;

{$ifdef MSWINDOWS}{$apptype CONSOLE}{$endif}
{$ifdef FPC}{$mode OBJFPC}{$H+}{$endif}

uses
  SysUtils, IPConnection, BrickletLaserRangeFinder;

type
  TExample = class
  private
    ipcon: TIPConnection;
    lrf: TBrickletLaserRangeFinder;
  public
    procedure ReachedCB(sender: TBrickletLaserRangeFinder; const distance: word);
    procedure Execute;
  end;

const
  HOST = 'localhost';
  PORT = 4223;
  UID = 'XYZ'; { Change to your UID }

var
  e: TExample;

{ Callback for distance greater than 20 cm }
procedure TExample.ReachedCB(sender: TBrickletLaserRangeFinder; const distance: word);
begin
  WriteLn(Format('Distance: %d cm.', [distance]));
end;

procedure TExample.Execute;
begin
  { Create IP connection }
  ipcon := TIPConnection.Create;

  { Create device object }
  lrf := TBrickletLaserRangeFinder.Create(UID, ipcon);

  { Connect to brickd }
  ipcon.Connect(HOST, PORT);
  { Don't use device before ipcon is connected }

  { Turn laser on and wait 250ms for very first measurement to be ready }
  lrf.EnableLaser;
  Sleep(250);

  { Get threshold callbacks with a debounce time of 10 seconds (10000ms) }
  lrf.SetDebouncePeriod(10000);

  { Register threshold reached callback to procedure ReachedCB }
  lrf.OnDistanceReached := {$ifdef FPC}@{$endif}ReachedCB;

  { Configure threshold for "greater than 20 cm" }
  lrf.SetDistanceCallbackThreshold('>', 20, 0);

  WriteLn('Press key to exit');
  ReadLn;
  ipcon.Destroy; { Calls ipcon.Disconnect internally }
end;

begin
  e := TExample.Create;
  e.Execute;
  e.Destroy;
end.