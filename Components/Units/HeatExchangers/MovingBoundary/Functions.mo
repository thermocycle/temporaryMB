within Components.Units.HeatExchangers.MovingBoundary;
package Functions
 extends Modelica.Icons.Package;

  annotation (Icon(graphics={
        Text(
          extent={{-114,86},{86,-114}},
          lineColor={255,127,0},
          textString=
               "f"), Ellipse(extent={{-74,64},{62,-88}}, lineColor={255,128,0})}));
  function Gamma
  input Real hh;
  input Real rho_l;
  input Real rho_v;
  input Real h_l;
  input Real h_v;
  output Real Gamma;
  algorithm
  Gamma:= rho_l*(hh -h_l) + rho_v*(h_v - h_l);
  end Gamma;

  function Theta
    input Real hh;
    input Real h_l;
    input Real drdp_l;
    input Real rho_l;
    input Real dhdp_l;
    input Real h_v;
    input Real drdp_v;
    input Real rho_v;
    input Real dhdp_v;
  algorithm
  Theta:= (hh - h_l)*drdp_l - rho_l*dhdp_l +(h_v - hh)*drdp_v +rho_v*dhdp_v;

  end Theta;
end Functions;
