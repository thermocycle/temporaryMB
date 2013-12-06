within Components.Units.HeatExchangers.MovingBoundary;
connector MBeva_port
Modelica.SIunits.Temperature TwSB
    "wall mean temperature in the subcooled region";
Modelica.SIunits.Temperature TwTP
    "wall mean temperature in the two-phase region";
Modelica.SIunits.Temperature TwSH
    "wall mean temperature in the superheated region";

flow Modelica.SIunits.Power QwSB "heat flow rate to the subcooled region";
flow Modelica.SIunits.Power QwTP "heat flow rate to the two-phase region";
flow Modelica.SIunits.Power QwSH "heat flow rate to the superheated region";

// Think about it!!!
output Modelica.SIunits.Length L_A "length of subcooled region";
output Modelica.SIunits.Length L_B "length of two-phase + subcooled region";

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
end MBeva_port;
