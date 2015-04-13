within MovingBoundaryLibrary.Components.Wall;
model Receiver
  "Receiver including ambiant losses -  Used to compare model against Bonilla's one"
  parameter Integer nCV = 3 "Number of volumes"  annotation(Dialog(__Dymola_label="Nº of CVs:"));
  Modelica.Blocks.Interfaces.RealInput Irr annotation (Placement(
          transformation(extent={{-130,-20},{-90,20}},rotation=0)));
  Interfaces.MbIn mbIn[nCV]
    annotation (Placement(transformation(extent={{88,-10},{108,10}})));

  //parameter Modelica.SIunits.LinearTemperatureCoefficient alpha=1 "Temperature coefficient of heat flow rate";
  parameter Modelica.SIunits.Length PTC_Height = 2.4;
  parameter Modelica.SIunits.Temperature T_amb = 300;
  parameter Modelica.SIunits.Diameter D_outer = 0.07;
  Modelica.SIunits.Power Qamb[nCV];
  Modelica.SIunits.Area  A[nCV];
  Modelica.SIunits.Length ll[nCV];
  Real Cdot_dummy[nCV];
  parameter Modelica.SIunits.Emissivity epsilon "Emissivity" annotation(Dialog(__Dymola_label="Emissivity:"));

protected
   Real IrrVector[nCV] = {Irr for i in 1:nCV};

equation
  for i in 1:nCV loop
    mbIn[i].Q_flow = -IrrVector[i]*ll[i]*PTC_Height+Qamb[i]; //epsilon*(Modelica.Constants.pi*D_outer*ll[i])*Modelica.Constants.sigma*(mbIn[i].T^4-T_amb^4);
    Qamb[i] = epsilon*A[i]*Modelica.Constants.sigma*(mbIn[i].T^4-T_amb^4);
    A[i] = (Modelica.Constants.pi*D_outer*ll[i]);
    mbIn[i].Cdot = Cdot_dummy[i];
    mbIn[i].ll = ll[i];
  end for;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),               Icon(graphics={
          Text(
            extent={{-117,43},{-77,23}},
            lineColor={0,0,127},
            lineThickness=0.5,
            textString=
                 "Irr"),
          Ellipse(
            extent={{-6,80},{-80,-80}},
            lineColor={85,255,255},
            fillColor={85,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{60,80},{-40,80},{-80,0},{-40,-80},{64,-80},{80,0},{80,
                0},{80,0},{60,80}},
            lineColor={85,255,255},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={85,255,255}),
          Ellipse(
            extent={{100,82},{28,-82}},
            lineColor={255,255,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(
            points={{50,78},{-50,50},{-2,8}},
            color={255,255,0},
            thickness=0.5,
            arrow={Arrow.None,Arrow.Filled}),
          Line(
            points={{-3,4},{-41,-24},{50,-78}},
            color={255,255,0},
            thickness=0.5,
            arrow={Arrow.Filled,Arrow.None}),
          Text(
            extent={{-100,100},{100,88}},
            lineColor={0,128,255},
            lineThickness=0.5,
            textString=
                 "Parabolic-trough receiver"),
          Line(
            points={{-52,6},{56,6},{-8,6}},
            color={0,128,255},
            thickness=0.5),
          Line(
            points={{-52,6},{-80,0}},
            color={0,0,0},
            thickness=0.5),
          Line(
            points={{55,6},{27,0}},
            color={0,0,0},
            thickness=0.5)}));
end Receiver;
