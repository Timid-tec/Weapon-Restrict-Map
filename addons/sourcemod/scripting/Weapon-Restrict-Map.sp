/*  [CS:GO] Weapon-Restrict-Map: Just a fun plugin, for maps, also.
 *
 *  Copyright (C) 2021 Mr.Timid // timidexempt@gmail.com
 * 
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) 
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with 
 * this program. If not, see http://www.gnu.org/licenses/.
 */

#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <sdkhooks>
#include <timid>

public Plugin myinfo = 
{
	name = "Weapon-Restrict-Map", 
	author = PLUGIN_AUTHOR, 
	description = "Disabled Weapon pickup/buy via map", 
	version = "4.2.2", 
	url = "https://steamcommunity.com/id/MrTimid/"
};

char currentMap[PLATFORM_MAX_PATH];
bool b_FoundMap;

char g_disabledWeapons[][PLATFORM_MAX_PATH] = {
	"", /* leave this empty when adding more weapons */
	"m249", 
	"negev", 
	"decoy", 
	"flashbang", 
	"molotov", 
	"incgrenade", 
	"smokegrenade"
};

char g_disabledMaps[][PLATFORM_MAX_PATH] = {
	"", /* leave this empty when adding more maps */
	"surf_buzzkill_mg", 
	"surf_ny_bigloop_kg_n", 
	"surf_colos2_mg_v2", 
	"surf_greatriver_so"
}

char g_disabledWeaponsViaMap[][] = {
	"", /* leave this empty when adding more weapons */
	"g3sg1", 
	"awp", 
	"scar20"
}

char WeaponName[128];

public void OnPluginStart()
{
	HookEvent("item_equip", Event_ItemEquip)
}

public void OnMapStart()
{
	GetCurrentMap(currentMap, sizeof(currentMap));
	
	b_FoundMap = false;
	
	for (int x = 1; x < sizeof(g_disabledMaps); x++) //start on 1 while [0] is blank
	{
		if (StrEqual(currentMap, g_disabledMaps[x], false))
		{
			b_FoundMap = true;
		}
	}
}


public Action Event_ItemEquip(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	int primary = GetPlayerWeaponSlot(client, 0);
	
	GetEventString(event, "item", WeaponName, sizeof(WeaponName));
	
	if (!IsValidClient(client))
		return Plugin_Handled;
	
	for (int x = 1; x < sizeof(g_disabledWeapons); x++)
	{
		if (StrEqual(WeaponName, g_disabledWeapons[x], false))
		{
			//PrintToChatAll(" \x10[WR] Debug\x0A - Weapon: %s", g_disabledWeapons[x]);
			RemovePlayerItem(client, primary);
		}
		for (int z = 1; z < sizeof(g_disabledWeaponsViaMap); z++)
		{
			if (StrEqual(WeaponName, g_disabledWeaponsViaMap[z], false) && b_FoundMap)
			{
				//PrintToChatAll(" \x10[WR] Debug ItemEqup\x0A - Map: %s Weapon %s Bool Value: %s", currentMap, g_disabledWeaponsViaMap[z], b_FoundMap ? "true" : "false");
				RemovePlayerItem(client, primary);
			}
		}
	}
	return Plugin_Continue;
}

public Action CS_OnBuyCommand(int client, const char[] sWeapon)
{
	
	for (int x = 1; x < sizeof(g_disabledWeapons); x++)
	{
		if (StrEqual(sWeapon, g_disabledWeapons[x], false))
		{
			//PrintToChatAll(" \x10[WR] Debug\x0A - Weapon: %s", g_disabledWeapons[x]);
			return Plugin_Handled;
		}
		for (int z = 1; z < sizeof(g_disabledWeaponsViaMap); z++)
		{
			if (StrEqual(sWeapon, g_disabledWeaponsViaMap[z], false) && b_FoundMap)
			{
				//PrintToChatAll(" \x10[WR] Debug OnBuyCommand\x0A - Map: %s Weapon %s Bool Value: %s", currentMap, g_disabledWeaponsViaMap[z], b_FoundMap ? "true" : "false");
				return Plugin_Handled;
			}
		}
	}
	return Plugin_Continue;
} 