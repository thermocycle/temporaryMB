within Components.Units.HeatExchangers.MovingBoundary;
model WallSegmentCut "Wall of variable length between two heat ports"

  // Geometry specification
  parameter Modelica.SIunits.Length s_ab(displayUnit="mm") = 0.001
    "thickness, from A to B"
  annotation (Dialog(group="Geometry"));
  parameter Modelica.SIunits.Length width = 0.1 "width of an equivalent plate"
  annotation (Dialog(group="Geometry"));
  // other geometric details, not parameters
  input Modelica.SIunits.Length length "length of the current segment";
  Modelica.SIunits.Area area_a = width*length "heat exchange area on side A";
  Modelica.SIunits.Area area_b = area_a "heat exchange area on side B";

  // Thermal properties
  Modelica.SIunits.Mass m_wall = (area_a+area_b)/2.0 * s_ab * wallProperties.rho
    "mass of the wall";
  replaceable
    Components.Units.HeatExchangers.MovingBoundary.Materials.DefaultWall
                          wallProperties constrainedby
    BaseClasses.BaseWallProperties
    annotation (choicesAllMatching=true,Dialog(group="Thermal properties"),Placement(transformation(extent={{-10,-10},{10,10}})));

  parameter Modelica.SIunits.Temperature Tstart_wall
    "Start value for temperature"
    annotation (Dialog(tab="Initialization"));
  parameter Boolean steadystate_T_wall=true
    "set derivative of T_wall to zero during initialization"
    annotation (Dialog(group="Intialization options", tab="Initialization"));

  Modelica.SIunits.Temperature T_wall(start=Tstart_wall) "Cell temperature";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b(T(start=Tstart_wall))
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}}),
        iconTransformation(extent={{-10,-40},{10,-20}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a(T(start=Tstart_wall))
    annotation (Placement(transformation(extent={{-10,20},{10,40}}),
        iconTransformation(extent={{-10,20},{10,40}})));

initial equation
  if steadystate_T_wall then
    der(T_wall) = 0.0;
  end if;

equation
  // Energy balance around lumped capacity
  m_wall*der(T_wall)*wallProperties.cp = port_a.Q_flow + port_b.Q_flow;

  port_a.Q_flow = wallProperties.lambda / (0.5*s_ab) * area_a * (port_a.T - T_wall);
  port_b.Q_flow = wallProperties.lambda / (0.5*s_ab) * area_b * (port_b.T - T_wall);

  annotation (Diagram(graphics), Icon(graphics={
        Rectangle(
          extent={{-80,20},{80,-20}},
          lineColor={135,135,135},
          fillColor={215,215,215},
          fillPattern=FillPattern.Backward),
        Text(
          extent={{20,50},{60,30}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Backward,
          textString="A"),
        Text(
          extent={{20,-30},{60,-50}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Backward,
          textString="B"),
        Text(
          extent={{-80,16},{80,-16}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Backward,
          textString="%name")}));
end WallSegmentCut;
