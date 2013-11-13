within Components.Units.HeatExchangers.MovingBoundary;
model MBportTotal
Modelica.SIunits.Temperature Tw_SB
    "wall mean temperature in the subcooled region";
Modelica.SIunits.Temperature Tw_TP
    "wall mean temperature in the two-phase region";
Modelica.SIunits.Temperature Tw_SH
    "wall mean temperature in the two-phase region";
flow Modelica.SIunits.Power Qw_SB "heat flow rate to the subcooled region";
flow Modelica.SIunits.Power Qw_TP "heat flow rate to the two-phase region";
flow Modelica.SIunits.Power Qw_SH "heat flow rate to the two-phase region";

// Think about it!!!
output Modelica.SIunits.Length L_SB "length of subcooled region";
output Modelica.SIunits.Length L_TP "length of subcooled region";
//output Modelica.SIunits.Length Lb
//    "total length of subcooled and two-phase regions";

  annotation (Icon(graphics={Rectangle(
          extent={{-60,20},{60,-20}},
          lineColor={0,0,255},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-52,16},{50,-14}},
          lineColor={0,0,255},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          textString="MBport")}));
end MBportTotal;
