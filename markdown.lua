--[[

MODIFIED FORM OF PICOML V2.3 LIBRARY

Support from @soupster to embed the font in this .lua library
Minie & widesquat font by @thelxinoe5 
]]--

--[[

Copyright (c) 2008 Niklas Frykholm
Copyright (c) 2015 Peter Melnichenko

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

string matching taken from https://github.com/mpeterv/markdown
]]--

local ffetch=fetch --replaced in :init() - ensures locality
local webWarning=printh --replaced in :init() - ensures locality
local pageDirty=false
local buildingPage=false

local scripting=false

local fonts={
	widesquat={
		name="Widesquat",
		width=8,
		height=8,
		data=unpod("b64:bHo0APoFAAArBgAA8oFweHUAAygACAAABAUIBhADkA9wDycAD3EPdwAOBkAPdg9wAAIQDxAPYAAPIAEgDQAfcAAHIA9gBw8nEA4ADQAHBgEQD2APZg9gABwADPAmRzAnQAcFB0AFAgVABQAFQCUwBAYHBgQgAQMHAwEgByFAJAcgBQcCBwJAAnABAlATIBVQAgUCwCYABiAVUA8WDz8EAPAJIAYPDwMPDA8PBhAPDQ8MBgMPCyAGCwYLGgDwHgNQBiMGIAMmAyALBg8PBgswBgoGcAYDMAeAAyAPDCYDIAYrBiAHNiAHCQYDCgYA8QcJByAbChkgCgMHCAcgBgMHCwYgCgkmUADwEgYgBgsPDggGQAMAA0AGAAYDEAkGAwYJMAcABzADBgkGA0AA8A8ABiAODxMPGwMPHiAGCwobIAcLBwsHIA4jDiAHKwdYACADCgYA8B0TIA4DDxsPEw4gGwobIEMgCiYHIBsHGyAzCiAfFi8rIA8TDxcPGx8TIA4rB0QAYBMgBhsHDgoA8REbIA4DCggHIAo2IDsOICsKBiAvKx8WIBsEGyAbJiAKCMkA8FgjByADJgkgByYHIAYLkAogAwZgDhsOIAMHGwcwDhMOIAgOGw4wBgsHDiAOBgoWMA4LCgkHEAMHKyADACMgBgAmAxADGwcLIDMGMA8XLyswByswDhsHMAcbBwMgDhsOCSAGIzAHAwQHTwGgCTArDjAbCgYwHY0BYDALFgswG6AA8hIHBAMHIA4GBwYOIEMgBwYOBgdADAtABgsGME9-IA9VDyoEAPIGIA9BD38fXQ8_IAEfYw93ASAPEQ9EBADwMyAPAg8eDgoIIA4PFx8fDiAPGx8fDgQgDxwPNg93DzYPHCAeDx8ODwogDxwBD38PKg86IAEPZw9jD2cBIA9-D10Pf1wA8BwgDxwUFyABD2MPaw9jASAEDg8fDgRAD1VAAQ9zD2MPcwEgCA8cD38BDyIgGgDwEA4CIAEPdx9jATAPBQ9SDyBADxEPKg9EMAEPaw93D2taAPAjAAUABSBPVSAOBA8eDy0PJiAPER8hDyUPAiAPDA8eHyAPHCAIDx4IDyQPGiAPTgQBD0UkAFAiD18fEq0A8AMeCA88DxEGIA8QDwwPAg8MDxAdAPAFeh8iDxIgDx4PIAAPAg88IAgJDxAeAFAgLwIPIlIA8AIBCA8MCCAPEg8-DxIPAg8cICEA8FB_BA84IA8CBw8yDwIPMiAKDwIODxAPHCABH0APIA8YIAEPEBgNIAgPOAQPAgkgDzIHDxIPeA8YIA96D0IPAg8KD3IgDwkBD0sPbQ9mIA8aDycPIg9zDzIgCQ9KH0kPRm8AEToEAHAaIA8jD2IfigDwOA8MAAgPKg9NMA8MDxIPIQ9AIA99D3kPEQ89D10gAQkIDx4PLiAGDyQPfg8mDSAPJA9OBA9GCSAPCgkPWg9GDzAgDx4EAw9EuQDwDRQBDyQYIA86D1YPUg8wCCAEDxwEAwYgCA8CAQ9HAUIfIg8myADyAgwPJA9yDzAgBA82DywPJg9kEwA0Qg8wtwDwICMPEiAOD2QPHA8oD3ggBA8CBg8rDxlADg0IMA8KAg8SBDAECg8VDw0wBA8MBg4gYQAgFAS0AfATMAgOGCAIAQ8iDyAMIAEoASAND34MDxQPEiAEAQ8kDyIPMn0BQAEIIAkOABANpgCxfA8SDQggAS8gASDoAEAkDyANHgSxJg0PDCABCw0MDyY9AAGeAUEiDyQLGADxAw8iDy0PMA8MIA8cCAEIBCAfKhgAMA8cAA4A8AcUBQ8kBCAIARgEMAUQASABCw8oDQ8smQDwCjAPXgggKw0OIA0fJA9ED0IgDwIDFwUgARs_ABIChAFgMAgBCB8qNgDBFAgNIAkAAQADIAgEIgFAfiAPQEwAgWgGIAMEAwQJmgDwQxQgBS0BIAMNAw0DIAEAAQsMICoLDSAvFA9UDzIgFw8iDxIPDiABLyIBIAEOCw0CIAELCQsMIAYbDQ8OMA8VDQ8IBjAEAw8UBEACDwgDMAUMDQVvAKBjDQggCA0KBAgg")
	},
	minie={
		name="Minie",
		width=8,
		height=8,
		data=unpod("b64:bHo0AC8DAACtBgAA8KpweHUAAygACAAABAQIBhABkA9gDyAAD2EPdxAGD3AwD3YQARAPEA9gAA8gASAOAB9wQA9gBw8nEA93AA4ABwYgD2APZhAPRw9gAA3wJm8-ICxADA8zDEALDwwLQAsAC0ArMA8wDzwMCg8wIAMPDwwJAxAPPjZAPzAPPgAPYw82DxwPPggFCDAPGIAPDA8YUB8MIB8KQAQCBLAhAAEgHwVQAg8fAg4CIA8CDwcDBgcPAhAPBQQPAgEPBRMAEAUEAPAgAiARUA8CIQ0gAS0BIA8FDQcNCzANBw1wDQEwB4ABIAQtASANKw0gAz0gAwQNAQcGAPAsBAMgGwcUIAcBAwQDIA0BAwsNIAcELSANCw0LDSANCwYEDTABAAFADQANASAEDQENBDAHAAcwAQ0EDQE-APAOAA0gBg8JDw0BBiANCwcbIAMLAwsDIAYhBiADKwNWACABBwYA8BoRIAYBCg8JBiAbBxsgQSAkCw0gGwMbIDEHIBIvFSAPCQ8LCh8JIAYrA0EAYBEgDRsDBgoA8g4bIAYBBwQDIAc9IDsGIDsNIC8VEiAbDRsgGy0gB8IA8FghAyABLQQgAy0DIA0LkAcgDQRgBhsGIAEDGwMwBhEGIAQGGwYwDQsDBiAEDQcdMAYLBwQDEAEDKyABACEgDQAtARABGwMLIDENMA8LLxUwAyswBhsDMAMbAwEgBhsGBCANITADAQ0DRwHyKQQwKwYwGwcNMBwOAjALHQswGwYEDSADDQEDIAYNAw0GIEEgAw0GDQMwBAcBQA0LDTBPfyAPVQ8qBADyBSAPYw9-H10FIAUfYw93BSAPEQ9EBADwDiANDx4PDg8PCCAPDg8XHg8OIAIeCQQgDxwPNg93GAL0dyAZDgkCIAoFD38PKg86IAUPZw9jD2cFIA8eDy0PPw8zDx4gBg0GEyAFD2MPaw9jBSAECQ4JBEAPVUAFD3MPYw9zBSAICg9-BQ8iIA4JBAkOIAUPdx9jBTALD1IPIEAPEQ8qD0QwBQ9rD3cPawUgD38ADAAMIE9VMA9_D0IPUg9KD0IPfhAHDABABxAHAQoAHwEJAP---2hQD0oBBwA=")
	},
	picotron={
		name="Picotron lil",
		width=5,
		height=10,
		data=unpod("b64:bHo0AMwGAAAnBwAA8BJweHUAAygACAAABAUJCxADYAEgDxBAB7APcAAPECABDnAJAPAlFzAO8DRvDyAtQA0JDUAJBglACQAJQCkwDA8ODQoMIAMHDQcDEAcRgBgKAA8RDxsKDx8PBAQA8AYwBoAGDFAWABVQBgkGwEIAAgAVcA8eAAEEAPA6EA8ECgEGCAcEEAkEAgkgAgUCCwUPCgAUUARSBAJUAhAFAgcCBTAECgRwBAIwDYACEBQSEQAGCQ8NCxkGAAQGNAoABgkIBAIBDQgAMAYICRUA8ioVDRQADREHGAcABhEHGQYADRgEIgAGGQYZBgAGGQoYBjACAAJABAAEAiAEAgECBDANAA0wAgQIBAJMAPAOAAIQCgkeAQoABhkNKQAHGQcZBwAGCSEJBgAHSQdZACARDQYAkCEAChEOGQoAKSUA8QFCBwAKOAkGABkFAwUZAFENAwHQHxUvEQAJCw45AAZJBkkA8QEhAAY5CwYPDAcZBykABgkBsADxhA8fVABZCgBJBQMALxEfFQ8bDxEAKQYpACkKGAcADQgEAhENAAdRBwAREhQAClgKAgWwDQACBHAGCAoJCgARBykHIAohCgAYCikKIAYJDQEKAA8MEg0iIAoZCggGEQc5AAIAAyIHAAgADCgJBhEJBQMFCQADQgYgCx8VHxEgBzkgBikGIAcZBxEQChkKGBAPDQMhIJIB4AASDSIMIDkKICkFAyAfmgDgCiAZBhkgKQoIBhANCAZzAfYMEgEiBgAiACIGFAgkBgAOBVATHCBvfwAPVQ8qBADwCAAPQQ9jD38fXQ93Dz4ACx9jD3cLD0ELIwEWRAQA8A8ABAwPfAsPHw8YDxAADxwPJh9fD38LDxwADyIPdx8KAPAQCAAPKg8cDzYPdw82DxwPKgAfHAsPXQ8cHxQACA8cCy4AsSoPOgALD2cPYw9nYwARC3cA8QZ-D2MLAA8YD3goDQ8HAAsPYw9rD2MgAPMICA8UDyoPXQ8qDxQIMA9VMAsPcw9jD3McADEcD39wAPEEIhAPfw8iDxQIBw8iD38ACw93Hz8A8wEQDgQAD1APIBAPEQ8qD0QABwBxCw9rD3cPa0UAQQ9-AAkCAPAEb1UABA8fBAsPVQ9NDyYQDyIvQj4A8D8YAAsfQA8gDxwACgAPPwgED04PMwAED18PhAsfRQ8mAA9CD58Poh8iDykPMQAICw8QD3wPIA8BDw4AD0APMAwCDAEPQAAfEQ99LxEOEAsaAGN_ABgGDxAlAPETMg9CDyIKAAgJDA4MCAQAFQkFDzICDzwAAw8QCA-_DxAIAZYA8QkP5AQPEg-iAAQPPwQPNA9MD0APPxADD0ObAPE5HgAJCCQIAQAfEA94BBIPfAAED28EHyQPcg_yAA8BDz0fAQ8FD3kCAAgfCQsPSw-tD24AEg87D0YPQg-jD2IQAw9SD5EfiQ9GpwDwAh8RDzkPXRAPEw8SDzEPUQ8RygAA8gH1BQgND1IPiRAMDxIPIQ9AD4AQD30PMADwWAALCAsIDw4POQ9PAAgEDyQGDyYPIA0ADyQPTgQPBg8FD0YPOAAfEg98D5YPig9EAQAIDx4EBx9EDzgQDxIJD0IPMhQADQ89H1MPUQ89CAAYDzgIDA8aD2wADAACDzoPRg9AAwAPICVWAACSAZUKAw9GD0EPTAPJADVDD8IXACUgChcA8A4jDxoADwcCD24PGQ8UAgMAFAIPDg8SD5EPcSAPOFcA8CQPIAogDxQLDyQYIA86D1YPUgEIIAgPOAgDDAAJD0APJA8UBAIPAQAPIA0MDwsoAAgJH0EMAPAIAAtICQAeD-4BDygPJgEABAkfRB9CD3GgAfEAGA9_HQAED3wPQg9BDg0MCwDwCBIPEQ0YAA8-PgYOABUJFQ0IAA8GCA8BgQDzEg4PHwAJH0AOAQ9MD4MABA90D08PJBQPeAAfQQ9CHg0PDkwA8AlJAQ9QDAAPOA8OCAkYBAAPRQ9JD0oPQA4iAPAGCwAJKAQAEgcPMiIAGAkoBBALIAkQvwDwHEQPKA0PLA8DAAgPfg9AAQwPKg9JAC4dCA8HAB8UDyQVH0EAHwEPGQ8HHwFGAlQvQA4NDOIBkCAICQgfKg9JDJ8A8g8FDxQIDQAPHg9gDwYPOAAPBw94ABgUD0IPcg_PAB9pAIAKD0cABhQJFCAAwHIPTwUPEiQQCx4dCUAAUA9_H0AJqABgEw4PHAA1GAHwCk8UD1IPMQA-AQ9BDzEPDwAJP0EJBwAJFwMdAEAJEw98CADwIA8BDwYTDg0PDzAPKg4NDCAECw8kFDAPHB0LIA8eDQINAgAYBA9jDRgAGA0BBBgA")
	},
	p8={
		name="Pico8",
		width=4,
		height=8,
		data=unpod("b64:bHo0AHoFAACjBQAA8INweHUAAygACAAABAQIBhAD8GpHMCdABwUHQAUCBUAFAAVAJTAEBgcGBCABAwcDASAHIUAkByAFBwIHAkACcAECUBMgFVACBQLAIgACIBVQBQcFBwUgBwMGBwIgBQQCAQUgEwYFByACAVACIQIgAiQCIAUCBwIFMAIHAmACAUAHgAIgBCIBIAclByADIgcgBwQHAQYA8QkGBAcgFQcUIAcBBwQHIBEHBQcgBzQgBwUJAPANBQcUMAIAAkACAAIBIAQCAQIEMAcABzABAgQCATwA8DQAAiACFQEGMAYFBwUwEwUHMAYRBjADFQMwBwMBBjAHAxEwBgEFBzAVBwUwBxIHMAcSAzAFAxUwIQYwFxUwAyUwBhUDPADwFQEwAgUDBjADBQMFMAYBBAMwByIwJQYwFQcCMBUXMAUSBTAFBxYA8SAEAQcgAyEDIAEiBCAGJAYgAgWQByACBFAHBQcVIAcFAwUHIAYhBiADJQcgBwEDAQYAUBEgBhEF4wAwFSAH9wDwBCIDIBUDFSAxByAXJSADNSAGJQPoAGARIAIVAwZFAPALFSAGAQcEAyAHMiA1BiAlBwIgJRcgFQIVIBUhAfIUBwQCAQcgBgIDAgYgQiADAgYCAzAEBwFAAgUCME9-IA9VDyoEAPIGIA9BD38fXQ8_IA4fYw93DiAPEQ9EBADwMiAEDzwPHA8eDxAgDxwPLh4PHCAPNh4PHAggDQ82D3cPNg0gHQ4NDxQgDQ4Pfw8qDzogDg9nD2MPZw4gD38PXQ9-WwDwESAPOBgfDiAOD2MPaw9jDiAIDQ4NCEAPVUAOD3MPYw9zEgCgD38ODyIgDg0IDSkA8Ap3H2MOMAUPUg8gQA8RDyoPRDAOD2sPdw9rVwDwIgAMAAwgT1UgDw4EDx4PLQ8mIA8RHyEPJQIgDwwPHh8gDSAIDx4IDyQPGiAPTgQOD0UiAHAiD18fEgogGQCwPA8RBiAPEA8MAgvXAPB4Ig96HyIPEiAPHg8gAAIPPCAICQ8QAgsgIg8iDSAIDggLCCAPEg8-DxICDSAJDxAPfgQPOCACBw8yAgMgDw8CDw4PEA0gDh9ADyAPGCAODxAYASAIDzgEAgkgAwcPEg94DxggD3oPQgIKD3IgDwkOD0sPbQ9mIA8aDycPIg9zAyAJD0ofSQ9GZQAROgQA8mQaIA8jD2IfIg0gCwAIDyoPTTALDxIPIQ9AIA99D3kPEQ89D10gDgkIDx4PLiAGDyQPfg8mASAPJA9OBA9GCSAKCQ9aD0YPMCAPHgQFD0QPOCAPFA4PJBggDzoPVg9SDzAIIAQNBAUGIAgCDg8gDSAfIg8mvADyAgwPJA9yDzAgBA82DywPJg9kEwA0Qg8wrwAQIygB8BoOD2QNDygPeCAEAgYPKw8ZQA8OAQgwCg8fDxIEMAQPDw8VDw0wBAsGD8oB8BogDxQEAiAPMAgPDhggCA4PIg8gDCAOKA4gAQ9_DA8UDxIgBA4PJA8iA2sBQA4IIAkNAPEBAQggBA98DxIBCCAOLyAOIOQA8QIkDyABIAYHDyYBCyAOBwEMBToAAI0BUA8iDyQHFgDwAg8iDy0PMAsgDxwIDggEIB8qFgAwDxwADQDwBxQNDyQEIAgOGAQwDRAOIA4HDygBDyyTAPMOMA9eCCAnAQ8OIAEfJA9ED0IgAg8eEg0gDhcBCyB7AWAwCA4IHyo2ANEUCAEgCQAOAA8eIAgEHgFAfiAPQE0AIGgGcwExCgQJmQDwExQgDSEOIAoBCgEKIA4ADgcMICMHASAvFA9UDzIgEg8iDxIgAWEvIg4gDgW9APASBwkHDCAGFwEPDjAPFQEPCAYwBAoPFARACw8ICjANDAENcACgYwEIIAgBAwQIIA==")
	},
}

local activeFont={
	width=5,
	height=10
}

local rootFolder="/appdata/picoml/"
local localStorageFolder=rootFolder.."localStorage/"
local sharedStorageFolder=rootFolder.."sharedStorage/"
mkdir(rootFolder)
mkdir(localStorageFolder)
mkdir(sharedStorageFolder)
local baseurl
local page={}

local function loadFont(font,primary)
--	memmap(0x4000,fonts.minie.data)
	if (type(font)!="table") then
		font=fonts.picotron
	end
	
	if (not secondary) then
		font.data:poke(0x4000)
		activeFont.width=font.width
		activeFont.height=font.width
	else
		font.data:poke(0x5600)
		activeFont.width=font.width
		activeFont.height=font.width
	end
end

local function cleanURL(url)
	local url,_=url:match("([^?]*)%??(.*)")
	url=url:sub(#url:prot()+4,#url)
	local rem="/main.picoml"
	if (url:sub(#url-#rem+1,#url)==rem) then
		url=url:sub(1,#url-#rem)
	end
	local sectors=url:split("/")
	return sectors[1] or url
end

--hell
local function rPath(path, base)
	base=base or baseurl
	local prot = ""
	
	if (path:prot()) return path
	
	local basePath,baseQuery=base:match("^([^?]*)%??(.*)$")
	local pathPart,query=path:match("^([^?]*)%??(.*)$")
	if path:match("^%?") then
		return basePath..path
	end
	
	local pathQuery=(query!="" and query) or nil
	
	if (basePath and basePath!="/") then
		local baseProt = basePath:prot()
		prot=baseProt and (baseProt.."://") or ""
		if (baseProt) then
			basePath=basePath:sub(#prot+1)
		end
		
		local last=basePath:match("[^/]+$")
		if (last) then
			last=last:match("^[^?]+")
			if (last:ext()) then
				basePath=basePath:sub(1,#basePath-#last)
			end
		end
		
		if (basePath:sub(-1)!="/") then
			basePath..="/"
		end
		if (not (path:match("^/"))) then
			pathPart=basePath..pathPart
		end
	end
	
	local segments = {}
	for part in pathPart:gmatch("[^/]+") do
		if (part=="..") then
			if (#segments>0) then
				table.remove(segments)
			end
		elseif (part!="." and part!="") then
			table.insert(segments,part)
		end
	end
	
	pathPart=table.concat(segments, "/")
	
	local lastSegment=pathPart:match("[^/]+$") or ""
	local isFile=(lastSegment:ext()!=nil)
	local finalQuery=pathQuery or (isFile and baseQuery)
	if (finalQuery and finalQuery!="") then
		pathPart..="?"..finalQuery
	end
	return prot..pathPart
end

--resolved fetch, supports ../ and stuff
local function rFetch(path)
	return ffetch(rPath(path,baseurl))
end

--sandbox functs

local function sandboxedFunct(funct,safe_env,nilerror)
	if (nilerror==nil) nilerror=true
	if safe_env and type(safe_env[funct]) == "function" then
		local ok, err = pcall(safe_env[funct],safe_env)
		if not ok then
			webWarning(funct.."() error: " .. tostring(err))
		end
	elseif (nilerror) then
		webWarning(funct.." not found")
	end
end

--helper
local function swapCase(txt)
	txt=txt:gsub("%a", function(c)
		if c:match("%l") then
			return c:upper()
		else
			return c:lower()
		end
	end)
	return txt
end

local function openTab(url,replaceIndex)
	--handle a lack of protocol
	if (sub(url,1,4)!="self" and url:prot()==nil) then
		url="http://"..url
	end
	--handle self: protocol
	local display=url
	if (url:prot()=="self") then
		url=url:sub(8,#url)
		url="self/"..url
	end
	local path,query=url:match("([^?]*)%??(.*)")
	
	--redirect to main.picoml if nil
	local last=path:match("[^/]+$") or ""
	if (last:ext()==nil) then
		if (path:sub(-1)!="/") path..="/"
		path..="main.picoml"
	end
	
	if (query!="") then
		url=path.."?"..query
	else
		url=path
	end
	local selff=false
	if (type(replaceIndex)=="string") then
		if (replaceIndex=="self") selff=true
	end
	page:newTab(url,selff)
end

local function openRelativeTab(url,replaceIndex)
	if (url:prot()==nil) then
		url=rPath(url)
	end
	openTab(url,replaceIndex)
end

--page building

local function wrapText(text,width,charWidth)
	charWidth=charWidth or 5
	local res=""
	local cx=0
	local nl=1
	local fwidth=0
	local i=1
	
	if (text==nil) return "",0,0
	while true do
		local nextnl=text:find("\n",i)
		local segment=nextnl and text:sub(i,nextnl-1) or text:sub(i)
		
		for word in segment:gmatch("%S+") do
			local wordWidth=#word*charWidth
			local spaceWidth=(cx>0) and charWidth or 0
			
			if (wordWidth+spaceWidth>width) then
				res..="\n"
				cx=0
				nl+=1
				spaceWidth=0
			end
			
			if cx>0 then
				res..=" "
				cx+=charWidth
			end
			
			-- split long word if wider than line
			local start=1
			while (start<=#word) do
				local remainingWidth=width-cx
				local fitChars=flr(remainingWidth/charWidth)
				if (fitChars<=0) then
					res..="\n"
					cx=0
					nl+=1
					fitChars=flr(width/charWidth)
				end
				
				local part=word:sub(start,start+fitChars-1)
				res..=part
				cx+=#part*charWidth
				if (cx>fwidth) fwidth=cx
				start+=fitChars
				if (start<=#word) then
					res..="\n"
					cx=0
					nl+=1
				end
			end
		end
		if (not nextnl) break
		res..="\n"
		nl+=1
		cx=0
		i=nextnl+1
	end
	
	return res,nl,fwidth
end


--adds stuff like alignment and margins if missing

local function fixData(data,class,id,env)
	if (data.inline==nil) data.inline=unpod(pod(data)) --clone
	local inline=data.inline
	local element=data.type
	class=class or ""
	defaults=defaults or {}
	local push={}
	--priority:
	-- 1 data given in tag
	-- 2 id
	-- 3 class
	-- 4 element
	-- 5 pure defaults
	-- 6 default element
	
	push={ --pure defaults
		align="left",
		margin_left=0,
		margin_right=0,
		margin_top=0,
		margin_bottom=0
	}
	if (env.__styling.defaultElement[element]) then
		for k,v in pairs(env.__styling.defaultElement[element]) do
			push[k]=v
		end
	end
	if (env.__styling.element[element]) then
		for k,v in pairs(env.__styling.element[element]) do
			push[k]=v
		end
	end
    --split into different classes
    local classes=class:split(" ")
    for i=1, #classes do
    	if (classes[i]!="") then
	    	if (env.__styling.class[classes[i]]) then
	    		for k,v in pairs(env.__styling.class[classes[i]]) do
	    			push[k]=v
	    		end
	    	end
	    end
	end
    
	if (env.__styling.id[id]) then
		for k,v in pairs(env.__styling.id[id]) do
			push[k]=v
		end
	end
	
	for k,v in pairs(inline) do
		push[k]=v
	end
	
	for k,v in pairs(push) do
		data[k]=v
	end
	
	return data
end

local function applyMargin(data,x,y)
	return x+data.margin_left,y+data.margin_top
end

local function applyAlignment(align,x,y,width,height,pageData)
	if (align=="center") x=pageData.width/2-width/2
	if (align=="right") x=pageData.width-width
	return x,y
end

local objectHandler={
	text=function(data,builder,pageData,env,x,y)
		data=fixData(data,data.class,data.id,env)
		local pushbuild=true
		x,y=builder.x,builder.y
		local rawtext=data.rawtext or data.text
		local font=data.font
		local text,nl,width=wrapText(rawtext,pageData.width,font.width)
		local height=nl*font.height
		if (pushbuild) then
			builder.y+=data.margin_top+height+data.margin_bottom
		end
		x,y=applyAlignment(data.align,x,y,width,height,pageData)
		x,y=applyMargin(data,x,y)
		
		local el={
			x=x,y=y,
			width=width,height=height,
			rawtext=rawtext,
			text=text,
			hover=false,
			draw=function(self)
				local prefix=""
				loadFont(self.font)
				local c=self.color
				if (self.hover and self.hovercolor) then
					c=self.hovercolor
				end
				print(prefix..self.text,self.x,self.y,c)
				if (self.underline) then
					if (not self.underlinecache) self.underlinecache=self.text:gsub("[^\n]","_")
					print(prefix..self.underlinecache,self.x,self.y+2,c)
					print(prefix..self.underlinecache,self.x,self.y+2,c)
					print(prefix..self.underlinecache,self.x-1,self.y+2,c)
				end
			end
		}
		for k,v in pairs(data) do
			if (el[k]==nil) then
				el[k]=v
			end
		end
		return el,builder
	end,
	header=function(data,builder,pageData,env,x,y)
		data=fixData(data,data.class,data.id,env)
		local pushbuild=true
		x,y=builder.x,builder.y
		local rawtext=data.rawtext or data.text or ""
		local font=data.font
		--*2 because title
		local text,nl,width=wrapText(rawtext,pageData.width,font.width*2)
		if (font==2) text=swapCase(text)
		local height=nl*font.height*2
		if (pushbuild) then
			builder.y+=data.margin_top+height+data.margin_bottom
		end
		x,y=applyAlignment(data.align,x,y,width,height,pageData)
		x,y=applyMargin(data,x,y)
		local el={
			x=x,y=y,
			rawtext=data.text,
			text=text,
			width=width,height=height,
			hover=false,
			draw=function(self)
				local prefix=""
				loadFont(self.font)
				local c=self.color
				if (self.hover and self.hovercolor) then
					c=self.hovercolor
				end
				prefix..="\^p"
				print(prefix..self.text,self.x,self.y,c)
				print(prefix..self.text,self.x,self.y+1,c)
				print(prefix..self.text,self.x+1,self.y,c)
				print(prefix..self.text,self.x+1,self.y+1,c)
				if (self.underline) then
					if (not self.underlinecache) self.underlinecache=self.text:gsub("[^\n]","_")
					print(prefix..self.underlinecache,self.x,self.y+4,c)
					print(prefix..self.underlinecache,self.x-1,self.y+4,c)
					print(prefix..self.underlinecache,self.x-2,self.y+4,c)
					print(prefix..self.underlinecache,self.x-3,self.y+4,c)
				end
			end
		}
		for k,v in pairs(data) do
			if (el[k]==nil) then
				el[k]=v
			end
		end
		
		return el,builder
	end,
	link=function(data,builder,pageData,env,x,y)
		data=fixData(data,data.class,data.id,env)
		local pushbuild=true
		x,y=builder.x,builder.y
		local rawtext=data.rawtext or data.text or ""
		local font=data.font
		local text,nl,width=wrapText(rawtext,pageData.width,fonts[font].width)
		local height=nl*fonts[font].height
		if (pushbuild) then
			builder.y+=data.margin_top+height+data.margin_bottom
		end
		x,y=applyAlignment(data.align,x,y,width,height,pageData)
		x,y=applyMargin(data,x,y)
		local leftmouseclick=[[file.openPage(self.target,self.where)]]
		if (data.method=="download") then
			leftmouseclick=[[file.download(self.target)]]
		end
		local el={
			x=x,y=y,
			width=width,height=height,
			rawtext=rawtext,
			text=text,
			hover=false,
			draw=function(self)
				local c=self.color
				if (self.hover and self.hovercolor) then
					c=self.hovercolor
				end
				print(self.text,self.x,self.y,c)
				if (self.underline) then
					if (not self.underlinecache) self.underlinecache=self.text:gsub("[^\n]","_")
					print(self.underlinecache,self.x,self.y+2,c)
					print(self.underlinecache,self.x-1,self.y+2,c)
				end
			end,
			leftmouseclick=leftmouseclick,
			middlemouseclick=[[file.openPage(self.target,"new")]]
		}
		for k,v in pairs(data) do
			if (el[k]==nil) then
				el[k]=v
			end
		end
		
		return el,builder
	end,
	gap=function(data,builder,pageData,env,x,y)
		--input text
		data=fixData(data,data.class,data.id,env)
		local pushbuild=true
		x,y=builder.x,builder.y
		local height=data.height
		if (pushbuild) then
			builder.y+=data.margin_top+height+data.margin_bottom
		end
--		x,y=applyAlignment(data.align,x,y,width,height,pageData) why
		x,y=applyMargin(data,x,y) --also why but more seen why
		local el={
			x=x,y=y,
			width=0
		}
		for k,v in pairs(data) do
			if (el[k]==nil) then
				el[k]=v
			end
		end
		return el,builder
	end
}

--element method
local function callElementMethod(el, method)
	local fn=el[method]
	if (not fn) return
	
	local env=page.env
	
	local ok, err
	--has to be string functions to sandbox
	if (type(fn)=="string") then
		local success, compileErr=load("return function(self) "..fn.." end", "sandboxed", "t", env)
		if (not success) then
			webWarning("Sandbox failed to compile in "..method..": "..tostr(compileErr))
			return
		end
		local func=success()
		ok,err=pcall(func, el)
	elseif (type(fn)=="function") then
		ok, err = pcall(fn, el)
	else
		return
	end
	
	if (not ok) then
		webWarning("Sandbox runtime error in "..method..": "..tostr(err))
	end
end

--rip page

local fails={[[<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Not Found</title>
    <link href="/style.css" rel="stylesheet" type="text/css" media="all">
  </head>
  <body>
    <h1>Page Not Found</h1>
    <p>The requested page was not found.</p>
  </body>
</html>]],[[<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Error</title>
</head>
<body>
]]}

local function format(line)
	local obj={type="text",text=line}
	
	if (line=="") then
		obj.type = "gap"
		obj.text=nil
		return obj --no more processing needed
	end
	
	if (line:match("^    ")) then
		obj.text=obj.text:sub(5)
		obj.margin_left=15
	end
	
	local m1,m2=line:match("^(#+)[ \t]*(.-)[ \t]*#*[ \t]*$")
	if (m1) then
		obj.type="header"
		local level=m1:len()
		obj.class="header"..level
		obj.text=m2
	end
	
	return obj
end

local function ripPage(url,self)
	local raw=ffetch(url)
	if (raw==nil) return nil
	for i=1, #fails do
		if (raw:sub(0,#fails[i])==fails[i]) return nil
	end
	self.rippedPage={}
	local lines=split(raw,"\n")
	
	for i=1, #lines do
		add(self.rippedPage,format(lines[i]))
	end
	return self.rippedPage
end


local function drawPage(page,ud)
	local trg=get_draw_target()
	set_draw_target(ud)
	for i=1, #page do
		if (not page[i].ignore) then
			if (page[i].draw) page[i]:draw()
		end
	end
	set_draw_target(trg)
end

local function append(obj,page,builder,pageData,env,self)
	local funct=objectHandler[obj.type]
	if (funct) then
		local scriptingAttribs={
			leftmousedown=true,
			leftmouseclick=true,
			leftmouseunpress=true,
			rightmousedown=true,
			rightmouseclick=true,
			rightmouseunpress=true,
			middlemousedown=true,
			middlemouseclick=true,
			middlemouseunpress=true,
			wheelx=true,
			wheely=true,
			update=true,
			draw=true,
			__raw_update=true,
			enter=true,
			tab=true
		}
		local object,newBuilder=funct(obj,builder,pageData,env)
		--set custom values
		for key,val in pairs(obj) do
			object[key]=object[key] or val
		end
		for key,val in pairs(object) do
			if (scriptingAttribs[key]) then
				if (type(val)=="string") then
					local fn,err=load("return function(self) "..val.." end", key, "t", env)
					if (fn) then
						object[key]=fn()
					else
						webWarning("Failed to compile "..key..": "..tostr(err))
						object[key]=nil
					end
				end
			end
		end
		if (object.swapcase) then
			object.text=swapCase(object.text)
		end
		add(page,object)
		builder=newBuilder
		return object,true,"success"
	else
		obj.ignore=true
		add(page,obj)
		return obj,false,"no object handler"
	end
end

-- src being a url, filepath or a table
local function buildPage(src,pageData,env,self)
	buildingPage=true
	local page={idLookup={}}
	self.pageBuilder={
		x=0,y=0
	}
	local meta={title=baseurl:basename()}
	if (type(src)=="string") then
		src=ripPage(src,self)
	elseif (type(src)!="table") then
		return false,"can't handle type: "..type(src)
	end
	if (src==nil) printh("src is nil, failed to load page") return false,"src is nil"
	
	for i=1, #src do
		append(src[i],page,self.pageBuilder,self.pageData,env,self)
		--clear underline cache (for resizing)
		page[#page].underlinecache=nil
	end
	local height=self.pageBuilder.y
	drawPage(page,userdata("u8",1,1)) --flush anything that updates here, e.g: underlinecache
	buildingPage=false
	return src,page,meta,height -- return decompiled form of page, built page, metadata & new height
end

local function updatePage(self,page,cursorData)
	local x,y=cursorData.x,cursorData.y
	--get object at x,y
	local el
	for i=#page,1,-1 do
		if (not page[i].ignore) then
			if (page[i].__raw_update) callElementMethod(page[i],"__raw_update")
			if (page[i].update) callElementMethod(page[i],"update")
			if (page[i]) then
				if (#page>=i) then
					if (page[i].x and page[i].y and page[i].width and page[i].height) then
						if (page[i].x<=x and page[i].x+page[i].width>=x and page[i].y<=y and page[i].y+page[i].height>=y) then
							el=page[i]
						else
							page[i].hover=false
						end
					end
				end
			end
		end
	end
	if (el!=nil) then
		el.hover=true
		if (el.cursor) rawset(self.env,"__cursorSprite",el.cursor)
		--clicking / mousedown
		local mb,lb=cursorData.b,cursorData.lb
		local lclick,rclick,mwclick=lb==0 and mb==1,lb==0 and mb==2,lb==0 and mb==4
		local lunpress=(lb==1 or lb==3 or lb==5 or lb==7) and (lb==0 or lb==2 or lb==6 or lb==4)
		local runpress=(lb==2 or lb==3 or lb==6 or lb==7) and (lb==0 or lb==1 or lb==5 or lb==4)
		local munpress=(lb==4 or lb==5 or lb==6 or lb==7) and (lb==0 or lb==1 or lb==2 or lb==3)
		if (mb==1 or mb==3 or mb==5 or mb==7) then
			if (el.leftmousedown) callElementMethod(el,"leftmousedown")
			if (lclick) then
				if (el.leftmouseclick) callElementMethod(el,"leftmouseclick")
			end
			if (lunpress) then
				if (el.leftmouseunpress) callElementMethod(el,"leftmouseunpress")
			end
		end
		if (mb==2 or mb==3 or mb==6 or mb==7) then
			if (el.rightmousedown) callElementMethod(el,"rightmousedown")
			if (rclick) then
				if (el.rightmouseclick) callElementMethod(el,"rightmouseclick")
			end
			if (runpress) then
				if (el.rightmouseunpress) callElementMethod(el,"leftmouseunpress")
			end
		elseif (mb==4 or mb==6 or mb==7) then
			if (el.middlemousedown) callElementMethod(el,"middlemousedown")
			if (mwclick) then
				if (el.middlemouseclick) callElementMethod(el,"middlemouseclick")
			end
			if (munpress) then
				if (el.middlemouseunpress) callElementMethod(el,"middlemouseunpress")
			end
		end
		--scrollwheel
		local wheelx,wheely=cursorData.wheelx,cursorData.wheely
		if (wheelx!=0 and el.wheelx) callElementMethod(el,"wheelx")
		if (wheely!=0 and el.wheely) callElementMethod(el,"wheely")
	end
end

local alwaysAllowedFunctions={
	--debug
	warn=webWarning,
	webwarn=webWarning,
	webWarn=webWarning,
	webWarning=webWarning,
	printh=sandboxedPrinth,
	
	--text input
	key=key,
	keyp=keyp,
	peektext=peektext,
	readtext=readtext,
	
	--controller input
	btn=btn,
	btnp=btnp,
	
	--graphical
	
	cls=cls,
	color=color,
	clip=clip,
	circ=circ,
	circfill=circfill,
	camera=camera,
	fillp=fillp,
	flip=flip,
	get_display=get_display,
	get_draw_target=get_draw_target,
	set_draw_target=set_draw_target,
	line=line,
	oval=oval,
	ovalfill=ovalfill,
	rect=rect,
	rectfill=rectfill,
	tline=tline,
	tline3d=tline3d,
	pset=pset,
	pget=pget,
	print=print,
	pal=pal,
	palt=palt,
	
	--variables
	
	select=select,
	USERDATA=USERDATA,
	add=add,
	count=count,
	del=del,
	deli=deli,
	foreach=foreach,
	ipairs=ipairs,
	pairs=pairs,
	get=get,
	chr=chr,
	tonum=tonum,
	tonumber=tonumber,
	tostr=tostr,
	tostring=tostring,
	ord=ord,
	pack=pack,
	set=set,
	unpack=unpack,
	unpod=unpod,
	userdata=userdata,
	utf8=utf8,
	vec=vec,
	table=table,
	type=type,
	pod=pod,
	
	--logic
	abs=abs,
	all=all,
	atan2=atan2,
	blit=blit,
	ceil=ceil,
	cos=cos,
	flr=flr,
	mid=mid,
	min=min,
	math=math,
	max=max,
	string=string,
	sub=sub,
	rnd=rnd,
	sgn=sgn,
	sin=sin,
	split=split,
	sqrt=sqrt,
	srand=srand,
	t=t,
	time=time,
	
	--info
	date=date,
	stat=stat,
	
	--page backend
	fetch=sandboxedFetch
}

local function loadPermissions(environment,allowed)
	for i=1, #allowed do
		if (permittedFunctions[allowed[i]]) then
			for key,val in pairs(permittedFunctions[allowed[i]].functions) do
				environment[key]=val
			end
		end
	end
	--always allowed
	for key,val in pairs(alwaysAllowedFunctions) do
		environment[key]=val
	end
	return environment
end

--sandbox

local function buildEnvironment(permissions,data,pageData)
	local scriptEnvironment={}
	scriptEnvironment.__scroll={x=0,y=0}
	scriptEnvironment.__cursorData={x=0,y=0,rawx=0,rawy=0,b=0,wheelx=0,wheely=0,lb=0}
	scriptEnvironment.__lastCursorData={x=0,y=0,rawx=0,rawy=0,b=0,wheelx=0,wheely=0,lb=0}
	scriptEnvironment.__invertScrollX=data.invertScrollX or false
	scriptEnvironment.__invertScrollY=data.invertScrollY or false
	scriptEnvironment.__scrollSpeed=data.scrollSpeed or 8
	scriptEnvironment.__pageData=pageData
	scriptEnvironment.__viewport={width=0,height=0}
	scriptEnvironment.__styling={
		system={
			page={
				background=data.background or 7
			},
		},
		class={
			header1={
				font=fonts.picotron,
				underline=true
			},
			header2={
				font=fonts.widesquat,
				underline=true
			},
			header3={
				font=fonts.widesquat
			},
			header4={
				font=fonts.minie,
				underline=true
			},
			header5={
				font=fonts.minie
			},
			header6={
				font=fonts.minie,
				color=5
			}
		},
		id={},
		element={},
		defaultElement={
			header={color=0,font=fonts.picotron,cursor=1,margin_left=3},
			text={color=0,font=fonts.picotron,cursor=1,margin_left=3},
			link={color=12,hovercolor=1,font=fonts.picotron,cursor="pointer",where="new",method="webpage",underline=true},
			gap={height=11}
		},
	}
	scriptEnvironment=loadPermissions(scriptEnvironment,{})
	local code=[[
		function __raw_update()
			if (__invertScrollX) then
				__scroll.x+=__cursorData.wheelx*__scrollSpeed
			else
				__scroll.x-=__cursorData.wheelx*__scrollSpeed
			end
			if (__invertScrollY) then
				__scroll.y+=__cursorData.wheely*__scrollSpeed
			else
				__scroll.y-=__cursorData.wheely*__scrollSpeed
			end
			__scroll.x=mid(0,__scroll.x,max(0,__pageData.width-__viewport.width))
			__scroll.y=mid(0,__scroll.y,max(0,__pageData.height-__viewport.height))
			__scrollbarVisible=__pageData.height>__viewport.height
		end
	]]
	local fn,err=load(code, "script", "t", scriptEnvironment)
	if (not fn) then
		webWarning("RAW Script compile error: "..tostr(err))
	else
		local ok,err2=pcall(fn)
		if (not ok) then
			webWarning("Script runtime error: "..tostr(err2))
		else
			
		end
	end
	return scriptEnvironment
end

page.newTab=function(self,url,selff)
	self.browserCommunication.newTab(url,selff)
end

page.download=function(self,data,filename)
	self.browserCommunication.download(baseurl,data,filename)
end

page.setDisplay=function(self,width,height,generate)
	if (generate==nil) generate=true
	local lw,lh=self.width,self.height
	self.width=width
	self.height=height
	self.pageData.width=width
	if (generate and (self.width!=lw and self.height!=lh)) then
		pageDirty=true
	end
end

page.rip=function(self,url)
	if (url:ext()==nil) url=url.."/"
	if (url:sub(-1)=="/") then
		url=url.."main.picoml"
	end
	local rip=ripPage(url,self)
	local meta={}
	baseurl=url
	return rip,url
end

page.cleanRip=function(self,url)
	local rip,url=page:rip(url)
	if (rip==nil) return nil
	return rip,{title=url:basename()},url
end

page.rebuild=function(self)
	if (not self.hasinit) return
	self.idLookup={}
	if (not self.builtPage) then
		self.builtPage=self.rippedPage
	end
	_,self.builtPage,self.meta,self.pageData.height=buildPage(self.builtPage,self.pageData,self.env,self)
	self.browserCommunication.metadata(self.meta or {})
	for i=1, #self.builtPage do
		if (self.builtPage[i].init) self.builtPage[i]:init()
	end
end

local sfetch=function() end

page.init=function(self,data)
	baseurl=data.url
	local _
	webWarning=data.webWarning or printh
	self.env=buildEnvironment(data.permissions,data,self.pageData)
	self.pageData={width=0,height=0}
	self:setDisplay(data.width,data.height,false)
	self.rippedPage=ripPage(data.url,self)
	if (self.rippedPage==nil) return "404"
	self.lastcurs={}
	self.browserCommunication={}
	self.browserCommunication.newTab=data.newTab
	self.browserCommunication.metadata=data.metadata
	self.browserCommunication.download=data.download
	self.hasinit=true
	self:rebuild()
end

page.update=function(self,data)
	if (self.rippedPage==nil) return "404"
	if (not self.hasinit) return {}
	if (pageDirty) pageDirty=false self:rebuild()
	local curs=data.mousedata
	--ensure only affects if in page viewport
	if (curs.x<0 or curs.y<0 or curs.x>self.width or curs.y>self.height) then
		curs=self.env.__lastCursorData
	else
		curs.y+=self.env.__scroll.y
	end
	curs.lb=self.env.__lastCursorData.b
	self.env.__lastCursorData=curs
	rawset(self.env,"__cursorData",curs)
	rawset(self.env,"__pageData",self.pageData)
	rawset(self.env,"__viewport",{width=self.width,height=self.height})
	updatePage(self,self.builtPage,curs)
	sandboxedFunct("__raw_update",self.env,false)
	return {
		cursorSprite=self.env.__cursorSprite
	}
end

page.draw=function(self,x,y)
	if (self.hasinit==false or self.rippedPage==nil) return userdata("u8",1,1)
	local scroll=self.env.__scroll
	camera(scroll.x,scroll.y)
	local w,h=self.width,self.height
	local ud=userdata("u8",w,h)
	set_draw_target(ud)
	pal(0,32)
	cls(self.env.__styling.system.page.background)
	drawPage(self.builtPage,ud)
	camera()
	sandboxedFunct("_draw",self.env,false)
	if (self.env.__scrollbarVisible) then
		rectfill(w-5,th,w,h,13)
		local y=min(h-5,((scroll.y)/(self.pageData.height-h))*(h-5))
		rectfill(w-5,y,w,y+5,29)
	end
	set_draw_target()
	pal(0,0)
	palt(0,true)
	loadFont(fonts.picotron) --reset font for cart
	return ud
end

page.hasinit=false
return page,"0.1"
