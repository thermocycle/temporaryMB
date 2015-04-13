within MovingBoundaryLibrary.Components.Condenser;
model CondGeneral
 replaceable package Medium =
      ExternalMedia.Examples.WaterCoolProp constrainedby
    Modelica.Media.Interfaces.PartialMedium
                                           annotation (choicesAllMatching=true);

 /* Components */
   Interfaces.MbOut mbOut[nCV] annotation (Placement(transformation(extent={{-10,80},
            {10,100}})));
  Cells.OnePhase volumeSC(
    redeclare final package Medium = Medium,
    pstart=pstart,
    hstart=hstartSC,
    lstart=lstartSC,
    Mdotnom=Mdotnom,
    Unom=UnomSC,
    AA=AA,
    alone=false,
    YY=YY,
    eps_NTU=eps_NTU,
    Ltotal=Ltotal,
    Type=false,
    subcooled=true)
    annotation (Placement(transformation(extent={{44,-10},{64,10}})));
  Cells.TwoPhase volumeTP(
    redeclare final package Medium = Medium,
    pstart=pstart,
    hstart=hstartTP,
    lstart=lstartTP,
    Mdotnom=Mdotnom,
    Unom=UnomTP,
    AA=AA,
    alone=false,
    YY=YY,
    Ltotal=Ltotal,
    final Type=false,
    VoidFraction=VoidFraction,
    VoidF=VoidF,
    Flooded=false,
    General=true)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  ThermoCycle.Interfaces.Fluid.FlangeA InFlow(redeclare final package Medium =
               Medium)
    annotation (Placement(transformation(extent={{-112,-8},{-92,12}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutFlow(  redeclare final package Medium
      =                                                                           Medium)
    annotation (Placement(transformation(extent={{88,-8},{108,12}})));

  Cells.OnePhase volumeSH(
    redeclare final package Medium = Medium,
    pstart=pstart,
    Mdotnom=Mdotnom,
    AA=AA,
    alone=false,
    YY=YY,
    eps_NTU=eps_NTU,
    Ltotal=Ltotal,
    Type=false,
    Unom=UnomSH,
    hstart=hstartSH,
    lstart=lstartSH,
    subcooled=false)
    annotation (Placement(transformation(extent={{-46,-10},{-26,10}})));

import MovingBoundaryLibrary.Records;

/* Parameters */
final parameter Integer  nCV= 3;
parameter Modelica.SIunits.Area AA = 0.0019 "Channel cross section";
parameter Modelica.SIunits.Length YY = 1.57 "Channel perimeter";
parameter Modelica.SIunits.Length Ltotal=500
    "Total length of the heat exchanger";
parameter Boolean VoidFraction = true
    "Set to true to calculate the void fraction to false to keep it constant";
    parameter Real VoidF = 0.8 "Constantat void fraction" annotation (Dialog(enable= not VoidFraction));

/* Heat transfer */
parameter Boolean eps_NTU = false "Set to true for eps-NTU heat transfer" annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.MassFlowRate Mdotnom=0 "Nominal fluid flow rate" annotation (Dialog(group = "Heat transfer"));

parameter Modelica.SIunits.CoefficientOfHeatTransfer   UnomSH=3000 annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer   UnomTP=9000 annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer   UnomSC=2500 annotation (Dialog(group = "Heat transfer"));

  /* Initial values */
  parameter Modelica.SIunits.Pressure pstart=6e6 "Fluid pressure start value"
    annotation (Dialog(tab="Initialization"));

parameter Modelica.SIunits.Length lstartSH=1 "SH:Start value of length"
    annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Length lstartTP=1 "TP:Start value of length"
    annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Length lstartSC=1 "SC:Start value of length"
    annotation (Dialog(tab="Initialization"));

parameter Medium.SpecificEnthalpy hstartSH=1E5 "TP: Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
parameter Medium.SpecificEnthalpy hstartTP=1E5 "TP: Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
parameter Medium.SpecificEnthalpy hstartSC=1E5 "SC: Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));

  Records.Mode mode[nCV];

equation
  volumeSC.mode = mode[nCV-2];
  volumeTP.mode = mode[nCV-1];
  volumeSH.mode = mode[nCV];

 mode[nCV-2] = Constants.ModeCompound;
 mode[nCV-1] = Constants.ModeCompound;
 mode[nCV] = Constants.ModeCompound;
  /* Geometric constraints */
  volumeSC.ll + volumeTP.ll + volumeSH.ll = Ltotal;
  volumeSC.la = 0;

   volumeSC.lb = volumeTP.la;
   volumeTP.lb = volumeSH.la;

initial equation
// der(volumeSC.ll) = 0;

equation

  connect(volumeTP.mbOut, mbOut[2]) annotation (Line(
      points={{10,9},{10,30},{20,30},{20,64},{0,64},{0,90}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(InFlow, volumeSH.inFlow) annotation (Line(
      points={{-102,2},{-72,2},{-72,0},{-46,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(volumeSH.outFlow, volumeTP.inFlow) annotation (Line(
      points={{-26,0.1},{-13,0.1},{-13,0},{0,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(volumeSH.mbOut, mbOut[1]) annotation (Line(
      points={{-36,9},{-36,44},{0,44},{0,83.3333}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(volumeTP.outFlow, volumeSC.inFlow) annotation (Line(
      points={{20,0.1},{32,0.1},{32,0},{44,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(volumeSC.outFlow,OutFlow)  annotation (Line(
      points={{64,0.1},{77,0.1},{77,2},{98,2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(mbOut[3], volumeSC.mbOut) annotation (Line(
      points={{0,96.6667},{0,66},{54,66},{54,9}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end CondGeneral;
