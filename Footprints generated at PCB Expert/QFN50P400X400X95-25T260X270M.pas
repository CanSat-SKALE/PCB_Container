Var
    CurrentLib : IPCB_Library;

Procedure CreateSMDComponentPad(NewPCBLibComp : IPCB_LibComponent, Name : String, Layer : TLayer, X : Real, Y : Real, OffsetX : Real, OffsetY : Real,
                                TopShape : TShape, TopXSize : Real, TopYSize : Real, Rotation: Real, CRRatio : Real, PMExpansion : Real, SMExpansion : Real,
                                PMFromRules : Boolean, SMFromRules : Boolean);
Var
    NewPad                      : IPCB_Pad2;
    PadCache                    : TPadCache;

Begin
    NewPad := PcbServer.PCBObjectFactory(ePadObject, eNoDimension, eCreate_Default);
    NewPad.HoleSize := MMsToCoord(0);
    NewPad.Layer    := Layer;
    NewPad.TopShape := TopShape;
    if TopShape = eRoundedRectangular then
        NewPad.SetState_StackCRPctOnLayer(eTopLayer, CRRatio);
    NewPad.TopXSize := MMsToCoord(TopXSize);
    NewPad.TopYSize := MMsToCoord(TopYSize);
    NewPad.RotateBy(Rotation);
    NewPad.MoveToXY(MMsToCoord(X), MMsToCoord(Y));
    NewPad.Name := Name;

    Padcache := NewPad.GetState_Cache;
    if (PMExpansion <> 0) or (PMFromRules = False) then
    Begin
        Padcache.PasteMaskExpansionValid   := eCacheManual;
        Padcache.PasteMaskExpansion        := MMsToCoord(PMExpansion);
    End;
    if (SMExpansion <> 0) or (SMFromRules = False) then
    Begin
        Padcache.SolderMaskExpansionValid  := eCacheManual;
        Padcache.SolderMaskExpansion       := MMsToCoord(SMExpansion);
    End;
    NewPad.SetState_Cache              := Padcache;

    NewPCBLibComp.AddPCBObject(NewPad);
    PCBServer.SendMessageToRobots(NewPCBLibComp.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,NewPad.I_ObjectAddress);
End;

Procedure CreateComponentTrack(NewPCBLibComp : IPCB_LibComponent, X1 : Real, Y1 : Real, X2 : Real, Y2 : Real, Layer : TLayer, LineWidth : Real, IsKeepout : Boolean);
Var
    NewTrack                    : IPCB_Track;

Begin
    NewTrack := PcbServer.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
    NewTrack.X1 := MMsToCoord(X1);
    NewTrack.Y1 := MMsToCoord(Y1);
    NewTrack.X2 := MMsToCoord(X2);
    NewTrack.Y2 := MMsToCoord(Y2);
    NewTrack.Layer := Layer;
    NewTrack.Width := MMsToCoord(LineWidth);
    NewTrack.IsKeepout := IsKeepout;
    NewPCBLibComp.AddPCBObject(NewTrack);
    PCBServer.SendMessageToRobots(NewPCBLibComp.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,NewTrack.I_ObjectAddress);
End;

Procedure CreateComponentArc(NewPCBLibComp : IPCB_LibComponent, CenterX : Real, CenterY: Real, Radius : Real, StartAngle : Real, EndAngle : Real, Layer : TLayer, LineWidth : Real, IsKeepout : Boolean);
Var
    NewArc                      : IPCB_Arc;

Begin
    NewArc := PCBServer.PCBObjectFactory(eArcObject,eNoDimension,eCreate_Default);
    NewArc.XCenter := MMsToCoord(CenterX);
    NewArc.YCenter := MMsToCoord(CenterY);
    NewArc.Radius := MMsToCoord(Radius);
    NewArc.StartAngle := StartAngle;
    NewArc.EndAngle := EndAngle;
    NewArc.Layer := Layer;
    NewArc.LineWidth := MMsToCoord(LineWidth);
    NewArc.IsKeepout := IsKeepout;
    NewPCBLibComp.AddPCBObject(NewArc);
    PCBServer.SendMessageToRobots(NewPCBLibComp.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,NewArc.I_ObjectAddress);
End;

Procedure CreateComponentQFN50P400X400X95_25T260X270M(Zero : integer);
Var
    NewPCBLibComp               : IPCB_LibComponent;
    NewPad                      : IPCB_Pad2;
    NewRegion                   : IPCB_Region;
    NewContour                  : IPCB_Contour;
    STEPmodel                   : IPCB_ComponentBody;
    Model                       : IPCB_Model;

Begin
    Try
        PCBServer.PreProcess;

        NewPCBLibComp := PCBServer.CreatePCBLibComp;
        NewPcbLibComp.Name := 'QFN50P400X400X95-25T260X270M';
        NewPCBLibComp.Description := 'Quad Flat No-Lead (QFN with Tab), 0.50 mm pitch; square, 6 pin X 6 pin, 4.00 mm L X 4.00 mm W X 0.95 mm H body';
        NewPCBLibComp.Height := MMsToCoord(0.95);

        CreateSMDComponentPad(NewPCBLibComp, '1', eTopLayer, -2.02, 1.25, 0, 0, eRoundedRectangular, 0.89, 0.26, 180, 53.85, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '2', eTopLayer, -2.02, 0.75, 0, 0, eRoundedRectangular, 0.89, 0.26, 180, 53.85, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '3', eTopLayer, -2.02, 0.25, 0, 0, eRoundedRectangular, 0.89, 0.26, 180, 53.85, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '4', eTopLayer, -2.02, -0.25, 0, 0, eRoundedRectangular, 0.89, 0.26, 180, 53.85, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '5', eTopLayer, -2.02, -0.75, 0, 0, eRoundedRectangular, 0.89, 0.26, 180, 53.85, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '6', eTopLayer, -2.02, -1.25, 0, 0, eRoundedRectangular, 0.89, 0.26, 180, 53.85, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '7', eTopLayer, -1.25, -2.02, 0, 0, eRoundedRectangular, 0.89, 0.26, 270, 53.85, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '8', eTopLayer, -0.75, -2.02, 0, 0, eRoundedRectangular, 0.89, 0.26, 270, 53.85, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '9', eTopLayer, -0.25, -2.02, 0, 0, eRoundedRectangular, 0.89, 0.26, 270, 53.85, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '10', eTopLayer, 0.25, -2.02, 0, 0, eRoundedRectangular, 0.89, 0.26, 270, 53.85, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '11', eTopLayer, 0.75, -2.02, 0, 0, eRoundedRectangular, 0.89, 0.26, 270, 53.85, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '12', eTopLayer, 1.25, -2.02, 0, 0, eRoundedRectangular, 0.89, 0.26, 270, 53.85, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '13', eTopLayer, 2.02, -1.25, 0, 0, eRoundedRectangular, 0.89, 0.26, 0, 53.85, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '14', eTopLayer, 2.02, -0.75, 0, 0, eRoundedRectangular, 0.89, 0.26, 0, 53.85, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '15', eTopLayer, 2.02, -0.25, 0, 0, eRoundedRectangular, 0.89, 0.26, 0, 53.85, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '16', eTopLayer, 2.02, 0.25, 0, 0, eRoundedRectangular, 0.89, 0.26, 0, 53.85, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '17', eTopLayer, 2.02, 0.75, 0, 0, eRoundedRectangular, 0.89, 0.26, 0, 53.85, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '18', eTopLayer, 2.02, 1.25, 0, 0, eRoundedRectangular, 0.89, 0.26, 0, 53.85, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '19', eTopLayer, 1.25, 2.02, 0, 0, eRoundedRectangular, 0.89, 0.26, 90, 53.85, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '20', eTopLayer, 0.75, 2.02, 0, 0, eRoundedRectangular, 0.89, 0.26, 90, 53.85, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '21', eTopLayer, 0.25, 2.02, 0, 0, eRoundedRectangular, 0.89, 0.26, 90, 53.85, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '22', eTopLayer, -0.25, 2.02, 0, 0, eRoundedRectangular, 0.89, 0.26, 90, 53.85, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '23', eTopLayer, -0.75, 2.02, 0, 0, eRoundedRectangular, 0.89, 0.26, 90, 53.85, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '24', eTopLayer, -1.25, 2.02, 0, 0, eRoundedRectangular, 0.89, 0.26, 90, 53.85, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '25', eTopLayer, 0, 0, 0, 0, eRectangular, 2.6, 2.5, 0, 0, -2.6, 0, True, False);

        NewRegion := PCBServer.PCBObjectFactory(eRegionObject, eNoDimension, eCreate_Default);
        NewContour := PCBServer.PCBContourFactory;
        NewContour.AddPoint(MMsToCoord(0), MMsToCoord(-1.35));
        NewContour.AddPoint(MMsToCoord(-1.2), MMsToCoord(-1.35));
        NewContour.AddPoint(MMsToCoord(-1.2156), MMsToCoord(-1.3488));
        NewContour.AddPoint(MMsToCoord(-1.2309), MMsToCoord(-1.3451));
        NewContour.AddPoint(MMsToCoord(-1.2454), MMsToCoord(-1.3391));
        NewContour.AddPoint(MMsToCoord(-1.2588), MMsToCoord(-1.3309));
        NewContour.AddPoint(MMsToCoord(-1.2707), MMsToCoord(-1.3207));
        NewContour.AddPoint(MMsToCoord(-1.2809), MMsToCoord(-1.3088));
        NewContour.AddPoint(MMsToCoord(-1.2891), MMsToCoord(-1.2954));
        NewContour.AddPoint(MMsToCoord(-1.2951), MMsToCoord(-1.2809));
        NewContour.AddPoint(MMsToCoord(-1.2988), MMsToCoord(-1.2656));
        NewContour.AddPoint(MMsToCoord(-1.3), MMsToCoord(1.3));
        NewContour.AddPoint(MMsToCoord(-1.25), MMsToCoord(1.35));
        NewContour.AddPoint(MMsToCoord(1.2), MMsToCoord(1.35));
        NewContour.AddPoint(MMsToCoord(1.2156), MMsToCoord(1.3488));
        NewContour.AddPoint(MMsToCoord(1.2309), MMsToCoord(1.3451));
        NewContour.AddPoint(MMsToCoord(1.2454), MMsToCoord(1.3391));
        NewContour.AddPoint(MMsToCoord(1.2588), MMsToCoord(1.3309));
        NewContour.AddPoint(MMsToCoord(1.2707), MMsToCoord(1.3207));
        NewContour.AddPoint(MMsToCoord(1.2809), MMsToCoord(1.3088));
        NewContour.AddPoint(MMsToCoord(1.2891), MMsToCoord(1.2954));
        NewContour.AddPoint(MMsToCoord(1.2951), MMsToCoord(1.2809));
        NewContour.AddPoint(MMsToCoord(1.2988), MMsToCoord(1.2656));
        NewContour.AddPoint(MMsToCoord(1.3), MMsToCoord(-1.25));
        NewContour.AddPoint(MMsToCoord(1.2988), MMsToCoord(-1.2656));
        NewContour.AddPoint(MMsToCoord(1.2951), MMsToCoord(-1.2809));
        NewContour.AddPoint(MMsToCoord(1.2891), MMsToCoord(-1.2954));
        NewContour.AddPoint(MMsToCoord(1.2809), MMsToCoord(-1.3088));
        NewContour.AddPoint(MMsToCoord(1.2707), MMsToCoord(-1.3207));
        NewContour.AddPoint(MMsToCoord(1.2588), MMsToCoord(-1.3309));
        NewContour.AddPoint(MMsToCoord(1.2454), MMsToCoord(-1.3391));
        NewContour.AddPoint(MMsToCoord(1.2309), MMsToCoord(-1.3451));
        NewContour.AddPoint(MMsToCoord(1.2156), MMsToCoord(-1.3488));
        NewContour.AddPoint(MMsToCoord(1.2), MMsToCoord(-1.35));
        NewContour.AddPoint(MMsToCoord(0), MMsToCoord(-1.35));
        NewRegion.SetOutlineContour(NewContour);
        NewRegion.Layer := eTopLayer;
        NewPCBLibComp.AddPCBObject(NewRegion);

        NewRegion := PCBServer.PCBObjectFactory(eRegionObject, eNoDimension, eCreate_Default);
        NewContour := PCBServer.PCBContourFactory;
        NewContour.AddPoint(MMsToCoord(0), MMsToCoord(-1.35));
        NewContour.AddPoint(MMsToCoord(-1.2), MMsToCoord(-1.35));
        NewContour.AddPoint(MMsToCoord(-1.2156), MMsToCoord(-1.3488));
        NewContour.AddPoint(MMsToCoord(-1.2309), MMsToCoord(-1.3451));
        NewContour.AddPoint(MMsToCoord(-1.2454), MMsToCoord(-1.3391));
        NewContour.AddPoint(MMsToCoord(-1.2588), MMsToCoord(-1.3309));
        NewContour.AddPoint(MMsToCoord(-1.2707), MMsToCoord(-1.3207));
        NewContour.AddPoint(MMsToCoord(-1.2809), MMsToCoord(-1.3088));
        NewContour.AddPoint(MMsToCoord(-1.2891), MMsToCoord(-1.2954));
        NewContour.AddPoint(MMsToCoord(-1.2951), MMsToCoord(-1.2809));
        NewContour.AddPoint(MMsToCoord(-1.2988), MMsToCoord(-1.2656));
        NewContour.AddPoint(MMsToCoord(-1.3), MMsToCoord(1.3));
        NewContour.AddPoint(MMsToCoord(-1.25), MMsToCoord(1.35));
        NewContour.AddPoint(MMsToCoord(1.2), MMsToCoord(1.35));
        NewContour.AddPoint(MMsToCoord(1.2156), MMsToCoord(1.3488));
        NewContour.AddPoint(MMsToCoord(1.2309), MMsToCoord(1.3451));
        NewContour.AddPoint(MMsToCoord(1.2454), MMsToCoord(1.3391));
        NewContour.AddPoint(MMsToCoord(1.2588), MMsToCoord(1.3309));
        NewContour.AddPoint(MMsToCoord(1.2707), MMsToCoord(1.3207));
        NewContour.AddPoint(MMsToCoord(1.2809), MMsToCoord(1.3088));
        NewContour.AddPoint(MMsToCoord(1.2891), MMsToCoord(1.2954));
        NewContour.AddPoint(MMsToCoord(1.2951), MMsToCoord(1.2809));
        NewContour.AddPoint(MMsToCoord(1.2988), MMsToCoord(1.2656));
        NewContour.AddPoint(MMsToCoord(1.3), MMsToCoord(-1.25));
        NewContour.AddPoint(MMsToCoord(1.2988), MMsToCoord(-1.2656));
        NewContour.AddPoint(MMsToCoord(1.2951), MMsToCoord(-1.2809));
        NewContour.AddPoint(MMsToCoord(1.2891), MMsToCoord(-1.2954));
        NewContour.AddPoint(MMsToCoord(1.2809), MMsToCoord(-1.3088));
        NewContour.AddPoint(MMsToCoord(1.2707), MMsToCoord(-1.3207));
        NewContour.AddPoint(MMsToCoord(1.2588), MMsToCoord(-1.3309));
        NewContour.AddPoint(MMsToCoord(1.2454), MMsToCoord(-1.3391));
        NewContour.AddPoint(MMsToCoord(1.2309), MMsToCoord(-1.3451));
        NewContour.AddPoint(MMsToCoord(1.2156), MMsToCoord(-1.3488));
        NewContour.AddPoint(MMsToCoord(1.2), MMsToCoord(-1.35));
        NewContour.AddPoint(MMsToCoord(0), MMsToCoord(-1.35));
        NewRegion.SetOutlineContour(NewContour);
        NewRegion.Layer := eTopSolder;
        NewPCBLibComp.AddPCBObject(NewRegion);


        NewRegion := PCBServer.PCBObjectFactory(eRegionObject, eNoDimension, eCreate_Default);
        NewContour := PCBServer.PCBContourFactory;
        NewContour.AddPoint(MMsToCoord(-1.04), MMsToCoord(-1.09));
        NewContour.AddPoint(MMsToCoord(-1.04), MMsToCoord(-0.13));
        NewContour.AddPoint(MMsToCoord(-0.13), MMsToCoord(-0.13));
        NewContour.AddPoint(MMsToCoord(-0.13), MMsToCoord(-1.09));
        NewContour.AddPoint(MMsToCoord(-1.04), MMsToCoord(-1.09));
        NewRegion.SetOutlineContour(NewContour);
        NewRegion.Layer := eTopPaste;
        NewPCBLibComp.AddPCBObject(NewRegion);

        NewRegion := PCBServer.PCBObjectFactory(eRegionObject, eNoDimension, eCreate_Default);
        NewContour := PCBServer.PCBContourFactory;
        NewContour.AddPoint(MMsToCoord(0.13), MMsToCoord(-1.09));
        NewContour.AddPoint(MMsToCoord(0.13), MMsToCoord(-0.13));
        NewContour.AddPoint(MMsToCoord(1.04), MMsToCoord(-0.13));
        NewContour.AddPoint(MMsToCoord(1.04), MMsToCoord(-1.09));
        NewContour.AddPoint(MMsToCoord(0.13), MMsToCoord(-1.09));
        NewRegion.SetOutlineContour(NewContour);
        NewRegion.Layer := eTopPaste;
        NewPCBLibComp.AddPCBObject(NewRegion);

        NewRegion := PCBServer.PCBObjectFactory(eRegionObject, eNoDimension, eCreate_Default);
        NewContour := PCBServer.PCBContourFactory;
        NewContour.AddPoint(MMsToCoord(-1.04), MMsToCoord(0.13));
        NewContour.AddPoint(MMsToCoord(-1.04), MMsToCoord(1.09));
        NewContour.AddPoint(MMsToCoord(-0.13), MMsToCoord(1.09));
        NewContour.AddPoint(MMsToCoord(-0.13), MMsToCoord(0.13));
        NewContour.AddPoint(MMsToCoord(-1.04), MMsToCoord(0.13));
        NewRegion.SetOutlineContour(NewContour);
        NewRegion.Layer := eTopPaste;
        NewPCBLibComp.AddPCBObject(NewRegion);

        NewRegion := PCBServer.PCBObjectFactory(eRegionObject, eNoDimension, eCreate_Default);
        NewContour := PCBServer.PCBContourFactory;
        NewContour.AddPoint(MMsToCoord(0.13), MMsToCoord(0.13));
        NewContour.AddPoint(MMsToCoord(0.13), MMsToCoord(1.09));
        NewContour.AddPoint(MMsToCoord(1.04), MMsToCoord(1.09));
        NewContour.AddPoint(MMsToCoord(1.04), MMsToCoord(0.13));
        NewContour.AddPoint(MMsToCoord(0.13), MMsToCoord(0.13));
        NewRegion.SetOutlineContour(NewContour);
        NewRegion.Layer := eTopPaste;
        NewPCBLibComp.AddPCBObject(NewRegion);

        CreateComponentArc(NewPCBLibComp, 0, 0, 0.25, 0, 360, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 0.35, 0, -0.35, 0, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 0, 0.35, 0, -0.35, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -2.05, -2.05, -2.05, 2.05, eMechanical11, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, -2.05, 2.05, 2.05, 2.05, eMechanical11, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, 2.05, 2.05, 2.05, -2.05, eMechanical11, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, 2.05, -2.05, -2.05, -2.05, eMechanical11, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, -2.55, 1.88, -2.97, 1.88, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -2.97, 1.88, -2.97, -1.88, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -2.97, -1.88, -2.55, -1.88, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -2.55, -1.88, -2.55, -2.55, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -2.55, -2.55, -1.88, -2.55, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -1.88, -2.55, -1.88, -2.97, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -1.88, -2.97, 1.88, -2.97, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 1.88, -2.97, 1.88, -2.55, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 1.88, -2.55, 2.55, -2.55, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 2.55, -2.55, 2.55, -1.88, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 2.55, -1.88, 2.97, -1.88, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 2.97, -1.88, 2.97, 1.88, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 2.97, 1.88, 2.55, 1.88, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 2.55, 1.88, 2.55, 2.55, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 2.55, 2.55, 1.88, 2.55, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 1.88, 2.55, 1.88, 2.97, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 1.88, 2.97, -1.88, 2.97, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -1.88, 2.97, -1.88, 2.55, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -1.88, 2.55, -2.55, 2.55, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -2.55, 2.55, -2.55, 1.88, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -2.05, 1.61, -2.05, 2.05, eTopOverlay, 0.15, False);
        CreateComponentTrack(NewPCBLibComp, -2.05, 2.05, -1.61, 2.05, eTopOverlay, 0.15, False);
        CreateComponentTrack(NewPCBLibComp, -2.05, -1.61, -2.05, -2.05, eTopOverlay, 0.15, False);
        CreateComponentTrack(NewPCBLibComp, -2.05, -2.05, -1.61, -2.05, eTopOverlay, 0.15, False);
        CreateComponentTrack(NewPCBLibComp, 2.05, -1.61, 2.05, -2.05, eTopOverlay, 0.15, False);
        CreateComponentTrack(NewPCBLibComp, 2.05, -2.05, 1.61, -2.05, eTopOverlay, 0.15, False);
        CreateComponentTrack(NewPCBLibComp, 2.05, 1.61, 2.05, 2.05, eTopOverlay, 0.15, False);
        CreateComponentTrack(NewPCBLibComp, 2.05, 2.05, 1.61, 2.05, eTopOverlay, 0.15, False);

        CurrentLib.RegisterComponent(NewPCBLibComp);
        CurrentLib.CurrentComponent := NewPcbLibComp;
    Finally
        PCBServer.PostProcess;
    End;

    CurrentLib.Board.ViewManager_FullUpdate;
    Client.SendMessage('PCB:Zoom', 'Action=All' , 255, Client.CurrentView)
End;

Procedure CreateALibrary;
Var
    View     : IServerDocumentView;
    Document : IServerDocument;

Begin
    If PCBServer = Nil Then
    Begin
        ShowMessage('No PCBServer present. This script inserts a footprint into an existing PCB Library that has the current focus.');
        Exit;
    End;

    CurrentLib := PcbServer.GetCurrentPCBLibrary;
    If CurrentLib = Nil Then
    Begin
        ShowMessage('You must have focus on a PCB Library in order for this script to run.');
        Exit;
    End;

    View := Client.GetCurrentView;
    Document := View.OwnerDocument;
    Document.Modified := True;

    CreateComponentQFN50P400X400X95_25T260X270M(0);

End;

End.
