within Components.Units.HeatExchangers.MovingBoundary.BaseClasses;
partial record BaseWallProperties
  "Base class that defines the thermal properties of the wall"
  parameter Modelica.SIunits.SpecificHeatCapacity cp
    "Heat capacity of the wall";
  parameter Modelica.SIunits.Density rho "Density of the wall";
  parameter Modelica.SIunits.ThermalConductivity lambda
    "Heat conductivity of the wall";
  annotation (
  Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,100}}),
                               graphics={Rectangle(
          extent={{-80,100},{100,-80}},
          lineColor={0,0,0},
          fillColor={215,230,240},
          fillPattern=FillPattern.Solid), Rectangle(
          extent={{-100,80},{80,-100}},
          lineColor={0,0,0},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-68,50},{52,-70}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={215,230,240}),
        Text(
          extent={{-74,48},{60,-74}},
          pattern=LinePattern.None,
          fillColor={85,85,255},
          fillPattern=FillPattern.Solid,
          textString="S",
          lineColor={0,0,0})}),
  Documentation(info="<html>
<p><h4><font color=\"#008000\">Partial Wall Properties</font></h4></p>
<p>Definition of basic properties for a solid wall.</p>
</html>"));
end BaseWallProperties;
