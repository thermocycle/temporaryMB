within MovingBoundaryLibrary.Spline;
model Test2

  SplineSignal splineSignal(table=[0,10; 1,10; 2,15; 3,17; 4,20; 10,20; 12,
        20; 100,20])
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  annotation (experiment(StopTime=10), experimentSetupOutput);
end Test2;
