//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_WOTC_MorePsiAmps.uc                                    
//
//	File by RustyDios	
//
//	File created	07/09/20    17:00
//	LAST UPDATED    09/09/20    20:30
//
//  Gives new amp on load game, changes schematics, psionics image, sets several mod amps to implants
//
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_WOTC_MorePsiAmps extends X2DownloadableContentInfo;

var config bool bEnableOMPALog, bMergeBioticSchematics;

static event OnLoadedSavedGameToStrategy()
{
    CheckAndGiveImplantAmps('OneMorePsiAmp_CV', 'PsiAmp_CV');
    CheckAndGiveImplantAmps('OneMorePsiAmp_MG', 'PsiAmp_MG');
    CheckAndGiveImplantAmps('OneMorePsiAmp_BM', 'PsiAmp_BM');
}

static event InstallNewCampaign(XComGameState StartState){}

static event OnPostTemplatesCreated()
{
    ReplacePsionicsImage();
    ReplaceSchematicsImage();

    if (default.bMergeBioticSchematics)
    {
        MergeBioticSchematics();
    }

    //convertiontion        Amp             New Image                               New Archytpe                                #slots
    ConvertToImplantAmp('SectoidAmp_CV',"img:///More_PsiAmps.UI.INV_OMPA_CV","More_PsiAmps.Archetypes.WP_ObesPsiAmp_CV", class'X2Item_MorePsiAmps'.default.OneMorePsiAmp_SLOTS_CV);
    ConvertToImplantAmp('SectoidAmp_MG',"img:///More_PsiAmps.UI.INV_OMPA_MG","More_PsiAmps.Archetypes.WP_ObesPsiAmp_MG", class'X2Item_MorePsiAmps'.default.OneMorePsiAmp_SLOTS_MG);
    ConvertToImplantAmp('SectoidAmp_BM',"img:///More_PsiAmps.UI.INV_OMPA_BM","More_PsiAmps.Archetypes.WP_ObesPsiAmp_BM", class'X2Item_MorePsiAmps'.default.OneMorePsiAmp_SLOTS_BM);
    
    ConvertToImplantAmp('RM_BioAmp_CV',"img:///More_PsiAmps.UI.INV_OMBA_CV","", class'X2Item_MorePsiAmps'.default.OneMorePsiAmp_SLOTS_CV);
    ConvertToImplantAmp('RM_BioAmp_MG',"img:///More_PsiAmps.UI.INV_OMBA_MG","", class'X2Item_MorePsiAmps'.default.OneMorePsiAmp_SLOTS_MG);
    ConvertToImplantAmp('RM_BioAmp_BM',"img:///More_PsiAmps.UI.INV_OMBA_BM","", class'X2Item_MorePsiAmps'.default.OneMorePsiAmp_SLOTS_BM);
}

////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

static function ReplacePsionicsImage()
{
    local X2StrategyElementTemplateManager StrategyTemplateManager;
    local X2TechTemplate TechTemplate;

    StrategyTemplateManager = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

    TechTemplate = X2TechTemplate(StrategyTemplateManager.FindStrategyElementTemplate('Psionics'));
    if (TechTemplate != none)
    {
        TechTemplate.strImage = "img:///More_PsiAmps.UI.TECH_PsiResearch";
    }
}

static function ReplaceSchematicsImage()
{
    local X2ItemTemplateManager ItemTemplateManager;

    local X2DataTemplate ItemTemplate;
	local X2SchematicTemplate SchematicTemplate;

    ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

   	ItemTemplate = ItemTemplateManager.FindItemTemplate('PsiAmp_CV_Schematic');
	SchematicTemplate = X2SchematicTemplate(ItemTemplate);
	if(SchematicTemplate != none)
	{
		SchematicTemplate.strImage = "img:///More_PsiAmps.UI.TECH_PSIAMPS_CV";
	}

	ItemTemplate = ItemTemplateManager.FindItemTemplate('PsiAmp_MG_Schematic');
	SchematicTemplate = X2SchematicTemplate(ItemTemplate);
	if(SchematicTemplate != none)
	{
		SchematicTemplate.strImage = "img:///More_PsiAmps.UI.TECH_PSIAMPS_MG";
	}

	ItemTemplate = ItemTemplateManager.FindItemTemplate('PsiAmp_BM_Schematic');
	SchematicTemplate = X2SchematicTemplate(ItemTemplate);
	if(SchematicTemplate != none)
	{
		SchematicTemplate.strImage = "img:///More_PsiAmps.UI.TECH_PSIAMPS_BM";
	}

    //change biotics images
	ItemTemplate = ItemTemplateManager.FindItemTemplate('RM_BioAmp_MG_Schematic');
	SchematicTemplate = X2SchematicTemplate(ItemTemplate);
	if(SchematicTemplate != none)
	{
		SchematicTemplate.strImage = "img:///More_PsiAmps.UI.TECH_PSIAMPS_MG";
	}

	ItemTemplate = ItemTemplateManager.FindItemTemplate('RM_BioAmp_BM_Schematic');
	SchematicTemplate = X2SchematicTemplate(ItemTemplate);
	if(SchematicTemplate != none)
	{
		SchematicTemplate.strImage = "img:///More_PsiAmps.UI.TECH_PSIAMPS_BM";
	}

}

static function CheckAndGiveImplantAmps(name TemplateName, name MatchName, optional int Quantity = 1, optional bool bLoot = false)
{
	local X2ItemTemplateManager ItemManager;
	local X2ItemTemplate ItemTemplate, MatchTemplate;
	local XComGameState NewGameState;
	local XComGameState_Item ItemState;
	local XComGameState_HeadquartersXCom HQState;
	local XComGameStateHistory History;
	local bool bWasInfinite;

	ItemManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	ItemTemplate = ItemManager.FindItemTemplate(TemplateName);
	MatchTemplate = ItemManager.FindItemTemplate(MatchName);

	if (ItemTemplate == none || MatchTemplate == none)
	{
		`log("GIVE :: No item templates named" @TemplateName @"was found. OR No item templates named" @MatchName @"was found.",default.bEnableOMPALog,'OneMorePsiAmp');
		return;
	}

    //remove infinite flag to be able to give infinite items
	if (ItemTemplate.bInfiniteItem)
	{
		bWasInfinite = true;
		ItemTemplate.bInfiniteItem = false;
	}

	History = `XCOMHISTORY;
	HQState = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	`assert(HQState != none);

    //give the item on load game if HQ has the matching item
    if(HQState.HasItem(MatchTemplate))
    {
        NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Add Item Cheat: Create Item");
        ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
        ItemState.Quantity = Quantity;

        `XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

        NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Add Item Cheat: Complete");
        HQState = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(HQState.Class, HQState.ObjectID));
        HQState.PutItemInInventory(NewGameState, ItemState, bLoot);

        `XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

        `log("Added item" @TemplateName @ "object id" @ ItemState.ObjectID,default.bEnableOMPALog,'OneMorePsiAmp');
    }

    //reset the infintie flag for infinite items
    if (bWasInfinite)
    {
        bWasInfinite = false;
        ItemTemplate.bInfiniteItem = true;
    }
}

static function MergeBioticSchematics()
{
    local X2ItemTemplateManager ItemManager;
	local X2ItemTemplate ItemTemplate;
	local X2WeaponTemplate WeaponTemplate;

    local X2DataTemplate DataTemplate;
	local X2SchematicTemplate SchematicTemplate;

	ItemManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	ItemTemplate = ItemManager.FindItemTemplate('RM_BioAmp_MG');
	WeaponTemplate = X2WeaponTemplate(ItemTemplate);
	if (WeaponTemplate != none)
	{
        WeaponTemplate.CreatorTemplateName = 'PsiAmp_MG_Schematic';
    }

	ItemTemplate = ItemManager.FindItemTemplate('RM_BioAmp_BM');
	WeaponTemplate = X2WeaponTemplate(ItemTemplate);
	if (WeaponTemplate != none)
	{
        WeaponTemplate.CreatorTemplateName = 'PsiAmp_BM_Schematic';
    }

	DataTemplate = ItemManager.FindItemTemplate('RM_BioAmp_MG_Schematic');
	SchematicTemplate = X2SchematicTemplate(DataTemplate);
	if(SchematicTemplate != none)
	{
        SchematicTemplate.HideIfPurchased = 'RM_BioAmp_CV';
	}

	DataTemplate = ItemManager.FindItemTemplate('RM_BioAmp_BM_Schematic');
	SchematicTemplate = X2SchematicTemplate(DataTemplate);
	if(SchematicTemplate != none)
	{
        SchematicTemplate.HideIfPurchased = 'RM_BioAmp_CV';
	}

    `log("Biotics Schematics merged with Psionics",default.bEnableOMPALog,'OneMorePsiAmp');

}

static function ConvertToImplantAmp(name TemplateName, string ImagePath, string ArchetypePath, Int NumSlots)
{
    local X2ItemTemplateManager ItemManager;
	local X2ItemTemplate ItemTemplate;
	local X2WeaponTemplate WeaponTemplate;

	ItemManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	ItemTemplate = ItemManager.FindItemTemplate(TemplateName);
	WeaponTemplate = X2WeaponTemplate(ItemTemplate);

	if (WeaponTemplate != none)
	{
        if (ImagePath != "")
        {
            WeaponTemplate.strImage = ImagePath;
        }

        if (ArchetypePath != "")
        {
            WeaponTemplate.GameArchetype = ArchetypePath;
        }

        WeaponTemplate.NumUpgradeSlots = NumSlots;

        `log("Amp Converted to Implant :: " @ WeaponTemplate.DataName @" :: Image :: " @WeaponTemplate.strImage @" :: Archetype :: " @WeaponTemplate.GameArchetype @" :: Slots :: " @WeaponTemplate.NumUpgradeSlots,default.bEnableOMPALog,'OneMorePsiAmp');
    }
}
