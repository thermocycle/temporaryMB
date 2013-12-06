within Components.Units.HeatExchangers.MovingBoundary;
connector MBHTB_AD "Output MBHT connector"

Modelica.SIunits.Temperature Tliq
    "wall mean temperature in the subcooled region";
Modelica.SIunits.Temperature Tmix
    "wall mean temperature in the two-phase region";
Modelica.SIunits.Temperature Tvap
    "wall mean temperature in the superheated region";

flow Modelica.SIunits.Power Qliq "heat flow rate to the subcooled region";
flow Modelica.SIunits.Power Qmix "heat flow rate to the two-phase region";
flow Modelica.SIunits.Power Qvap "heat flow rate to the superheated region";

output Modelica.SIunits.Length La "length of subcooled region";
output Modelica.SIunits.Length Lb
    "total length of subcooled and two-phase regions";

  annotation (Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={95,95,95},
          fillColor={110,34,158},
          fillPattern=FillPattern.Solid), Text(
          extent={{-72,58},{72,-58}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textString=
               "B")}),      Diagram(graphics),
                                     Documentation(info="<html>
          <p>B-type MBHT connector, sends the lengths of subcooled and two-phase region to a A-type MBHT connector. 
          </html>",
             revisions="<html>
          <ul>
          <li><i>26 Sep 2007_</i>
            First release.</li>
          </ul>
          </html>"));

end MBHTB_AD;
