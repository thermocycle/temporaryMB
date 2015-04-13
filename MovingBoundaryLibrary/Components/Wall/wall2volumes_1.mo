within MovingBoundaryLibrary.Components.Wall;
model wall2volumes_1
  import Modelica.Constants;

protected
 parameter Integer n = 1 "number of volumes";
public
parameter Modelica.SIunits.SpecificHeatCapacity cp_w
    "Specific heat capacity (constant)"                                                       annotation(Dialog(group="Specific heat capacity",enable=cpw_sel==1,__Dymola_label="Constant value:"));
 parameter Modelica.SIunits.Length L_total "Total length of the Hx";
 parameter Modelica.SIunits.Mass M_w "Total mass flow of the wall";
 parameter Modelica.SIunits.Temperature TstartWall[n]
    "Start temperature of the wall";
 Modelica.SIunits.Length ll[n] = {QmbIn[i].ll for i in 1:n};
 Modelica.SIunits.Length la[n] "Left boundary of segment length";
 Modelica.SIunits.Length lb[n] "Right boundary of segment length";
 Modelica.SIunits.Temperature Tw[n]( start = TstartWall)
    "Inner wall temperature";

 Modelica.SIunits.Temperature Twa[n] "Left boundary temperature";
 Modelica.SIunits.Temperature Twb[n] "Right boundary temperature";

public
  Interfaces.MbIn QmbIn[n] annotation (Placement(transformation(extent={{-18,-100},{2,-80}})));

  Interfaces.MbOut QmbOut[n] annotation (Placement(transformation(extent={{-8,82},{12,102}})));
equation
  /*******  WallEnergyBalance SUB-COOLED **********/
la[1] = 0;
lb[1] = ll[1];

// First and last boundary temperatures
 Twa[1] = 0;
 Twb[n] = 0;

 // Wall Left boundary temperatures
//for i in 2:n loop
//   Twa[i] = Tw[i-1]*ll[i]/(ll[i-1]+ll[i]) + Tw[i]*ll[i-1]/(ll[i-1]+ll[i]);
//end for;

// Wall Right boundary temperatures
//for i in 1:n-1 loop
//   Twb[i] = Tw[i]*ll[i+1]/(ll[i]+ll[i+1]) + Tw[i+1]*ll[i]/(ll[i]+ll[i+1]);
//end for;

/* Wall energy balance */
for i in 1:n loop
     der(Tw[i]) = ((QmbIn[i].Q_flow + QmbOut[i].Q_flow)*L_total/(M_w*cp_w*ll[i])); //- (((Tw[i]-Twb[i])/Li[i])*der(Lb[i])
end for;

 // Connect In and Out Connectors length
 for i in 1:n loop
   QmbIn[i].ll = QmbOut[i].ll;
 end for;

 QmbOut.T = Tw;
 QmbIn.T = Tw;

 QmbIn.Cdot = QmbOut.Cdot;
 annotation (Icon(graphics={
       Line(
         points={{0,90},{0,20},{0,50},{0,34}},
         color={191,0,0},
         thickness=0.5),
       Line(
         points={{0,-20},{0,-90},{0,-60},{0,-76}},
         color={191,0,0},
         thickness=0.5),
       Rectangle(
         extent={{-100,20},{100,-20}},
         lineColor={0,0,0},
         pattern=LinePattern.None,
         fillPattern=FillPattern.Solid,
         fillColor={175,175,175})}),    Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                graphics={
       Text(
         extent={{8,96},{20,80}},
         lineColor={255,0,0},
         lineThickness=0.5,
         fillColor={85,255,255},
         fillPattern=FillPattern.Solid,
         textString=
              "qa"),
       Text(
         extent={{6,-82},{18,-98}},
         lineColor={255,0,0},
         lineThickness=0.5,
         fillColor={85,255,255},
         fillPattern=FillPattern.Solid,
         textString=
              "qb"),
       Rectangle(
         extent={{-100,20},{100,-20}},
         lineColor={0,0,0},
         pattern=LinePattern.None,
         fillPattern=FillPattern.HorizontalCylinder,
         fillColor={175,175,175})}));
end wall2volumes_1;
