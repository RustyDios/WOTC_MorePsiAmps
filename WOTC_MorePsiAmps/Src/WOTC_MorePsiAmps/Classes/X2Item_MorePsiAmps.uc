//---------------------------------------------------------------------------------------
//  FILE:   X2Item_MorePsiAmps.uc                                    
//
//	File by RustyDios	
//
//	File created	07/09/20    17:00
//	LAST UPDATED    29/10/20	18:00
//
//  creates new 'visual' amps, near exact clones of normal amps.. but implant icon and obe's invis amp anims
//
//---------------------------------------------------------------------------------------

class X2Item_MorePsiAmps extends X2Item config(GameData_WeaponData);

//commented values pulled forward from default weapons 
//var config array <WeaponDamageValue> PsiAmpT1_AbilityDamage;
//var config array <WeaponDamageValue> PsiAmpT2_AbilityDamage;
//var config array <WeaponDamageValue> PsiAmpT3_AbilityDamage;

// .... even base game amps don't actually have these set... 
//var config int PSIAMP_CONVENTIONAL_ISOUNDRANGE;
//var config int PSIAMP_CONVENTIONAL_IENVIRONMENTDAMAGE;

//var config int PSIAMP_MAGNETIC_ISOUNDRANGE;
//var config int PSIAMP_MAGNETIC_IENVIRONMENTDAMAGE;

//var config int PSIAMP_BEAM_ISOUNDRANGE;
//var config int PSIAMP_BEAM_IENVIRONMENTDAMAGE;

var config int OneMorePsiAmp_SLOTS_CV, OneMorePsiAmp_SLOTS_MG, OneMorePsiAmp_SLOTS_BM;
var config int OneMorePsiAmp_SELL_CV, OneMorePsiAmp_SELL_MG, OneMorePsiAmp_SELL_BM;
var config bool bHideImplantsInArmoryUntilPsionics, bOneMorePsiAmp_StartingItem, bOneMorePsiAmp_CanBeBuilt, bOneMorePsiAmp_InfiniteItem;
var config name OneMorePsiAmp_StartingPsiPerk;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;
	
	Weapons.AddItem(CreateTemplate_OneMorePsiAmp_Conventional());
	Weapons.AddItem(CreateTemplate_OneMorePsiAmp_Magnetic());
	Weapons.AddItem(CreateTemplate_OneMorePsiAmp_Beam());

	return Weapons;
}

// **************************************************************************
// ***                       Psi Amps                                     ***
// **************************************************************************

static function X2DataTemplate CreateTemplate_OneMorePsiAmp_Conventional()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'OneMorePsiAmp_CV');
	Template.WeaponPanelImage = "_PsiAmp";                       // used by the UI. Probably determines iconview of the weapon.
	Template.strImage = "img:///More_PsiAmps.UI.INV_OMPA_CV"; // "img:///UILibrary_Common.ConvSecondaryWeapons.PsiAmp";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'psiamp';
	Template.WeaponTech = 'conventional';
	Template.EquipSound = "Psi_Amp_Equip";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	Template.Tier = 0;

	// This all the resources; sounds, animations, models, physics, the works.
	//	Template.GameArchetype = "WP_PsiAmp_CV.WP_PsiAmp_CV";
		Template.GameArchetype = "More_PsiAmps.Archetypes.WP_ObesPsiAmp_CV";

	Template.Abilities.AddItem('PsiAmpCV_BonusStats');

	//should they give a starting perk?
	if (default.OneMorePsiAmp_StartingPsiPerk != 'none')
	{
		Template.Abilities.Additem(default.OneMorePsiAmp_StartingPsiPerk);
	}

	Template.DamageTypeTemplateName = 'Psi';
	Template.ExtraDamage = class'X2Item_DefaultWeapons'.default.PSIAMPT1_ABILITYDAMAGE;
	Template.NumUpgradeSlots = default.OneMorePsiAmp_SLOTS_CV;

	Template.UpgradeItem = 'OneMorePsiAmp_MG';		// The Item this upgrades into

	Template.StartingItem = default.bOneMorePsiAmp_StartingItem;
	Template.CanBeBuilt = default.bOneMorePsiAmp_CanBeBuilt;
	Template.bInfiniteItem = default.bOneMorePsiAmp_InfiniteItem;

	// Show In Armory Requirements
	if (default.bHideImplantsInArmoryUntilPsionics)
	{
		Template.ArmoryDisplayRequirements.RequiredTechs.AddItem('Psionics');
	}

	Template.TradingPostValue = default.OneMorePsiAmp_SELL_CV;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.PsiOffenseBonusLabel, eStat_PsiOffense, class'X2Ability_ItemGrantedAbilitySet'.default.PSIAMP_CV_STATBONUS, true);

	return Template;
}

static function X2DataTemplate CreateTemplate_OneMorePsiAmp_Magnetic()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'OneMorePsiAmp_MG');
	Template.WeaponPanelImage = "_PsiAmp";                       // used by the UI. Probably determines iconview of the weapon.
	Template.strImage = "img:///More_PsiAmps.UI.INV_OMPA_MG"; // "img:///UILibrary_Common.MagSecondaryWeapons.MagPsiAmp";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'psiamp';
	Template.WeaponTech = 'magnetic';
	Template.EquipSound = "Psi_Amp_Equip";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	Template.Tier = 2;

	// This all the resources; sounds, animations, models, physics, the works.
	//		Template.GameArchetype = "WP_PsiAmp_MG.WP_PsiAmp_MG";
			Template.GameArchetype = "More_PsiAmps.Archetypes.WP_ObesPsiAmp_MG";

	Template.Abilities.AddItem('PsiAmpMG_BonusStats');

	//should they give a starting perk?
	if (default.OneMorePsiAmp_StartingPsiPerk != 'none')
	{
		Template.Abilities.Additem(default.OneMorePsiAmp_StartingPsiPerk);
	}

	Template.DamageTypeTemplateName = 'Psi';
	Template.ExtraDamage = class'X2Item_DefaultWeapons'.default.PSIAMPT2_ABILITYDAMAGE;
	Template.NumUpgradeSlots = default.OneMorePsiAmp_SLOTS_MG;

	Template.CreatorTemplateName = 'PsiAmp_MG_Schematic'; 	// The schematic which creates this item
	Template.BaseItem = 'OneMorePsiAmp_CV'; 				// Which item this will be upgraded from
	Template.UpgradeItem = 'OneMorePsiAmp_BM';				// The Item this upgrades into

	Template.CanBeBuilt = default.bOneMorePsiAmp_CanBeBuilt;
	Template.bInfiniteItem = default.bOneMorePsiAmp_InfiniteItem;
	
	Template.TradingPostValue = default.OneMorePsiAmp_SELL_MG;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.PsiOffenseBonusLabel, eStat_PsiOffense, class'X2Ability_ItemGrantedAbilitySet'.default.PSIAMP_MG_STATBONUS);

	return Template;
}

static function X2DataTemplate CreateTemplate_OneMorePsiAmp_Beam()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'OneMorePsiAmp_BM');
	Template.WeaponPanelImage = "_PsiAmp";                       // used by the UI. Probably determines iconview of the weapon.
	Template.strImage = "img:///More_PsiAmps.UI.INV_OMPA_BM"; //"img:///UILibrary_Common.BeamSecondaryWeapons.BeamPsiAmp";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'psiamp';
	Template.WeaponTech = 'beam';
	Template.EquipSound = "Psi_Amp_Equip";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	Template.Tier = 4;

	// This all the resources; sounds, animations, models, physics, the works.
	//	Template.GameArchetype = "WP_PsiAmp_BM.WP_PsiAmp_BM";
		Template.GameArchetype = "More_PsiAmps.Archetypes.WP_ObesPsiAmp_BM";

	Template.Abilities.AddItem('PsiAmpBM_BonusStats');

	//should they give a starting perk?
	if (default.OneMorePsiAmp_StartingPsiPerk != 'none')
	{
		Template.Abilities.Additem(default.OneMorePsiAmp_StartingPsiPerk);
	}

	Template.DamageTypeTemplateName = 'Psi';
	Template.ExtraDamage = class'X2Item_DefaultWeapons'.default.PSIAMPT3_ABILITYDAMAGE;
	Template.NumUpgradeSlots = default.OneMorePsiAmp_SLOTS_BM;

	Template.CreatorTemplateName = 'PsiAmp_BM_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'OneMorePsiAmp_MG'; // Which item this will be upgraded from

	Template.CanBeBuilt = default.bOneMorePsiAmp_CanBeBuilt;
	Template.bInfiniteItem = default.bOneMorePsiAmp_InfiniteItem;
	
	Template.TradingPostValue = default.OneMorePsiAmp_SELL_BM;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.PsiOffenseBonusLabel, eStat_PsiOffense, class'X2Ability_ItemGrantedAbilitySet'.default.PSIAMP_BM_STATBONUS);

	return Template;
}
