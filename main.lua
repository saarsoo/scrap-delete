local THRESHOLD = 6

local function addonLoadedHandler(self, event, name)
  if name == 'Scrap' then
    onLoad();
    return;
  end
end

local function getFreeSlotCount()
  local available = 0

  for i=0, 4 do
    local slots, type = GetContainerNumFreeSlots(i)
    if type == 0 then
      available = available + slots
    end
  end
  return available
end

local b = CreateFrame("Button", "MyButton", UIParent, "UIPanelButtonTemplate")
b:SetSize(80 ,22) -- width, height
b:SetText("Clean bags!")
b:SetPoint("TOP")
b:SetScript("OnClick", function()
    local slotCount = getFreeSlotCount()
    local countToDelete = THRESHOLD - slotCount

    for bag, slot in Scrap:IterateJunk() do
      PickupContainerItem(bag, slot)
      DeleteCursorItem()
      countToDelete = countToDelete - 1
      if countToDelete <= 0 then
        return
      end
    end
end)
b:Hide()

local function checkInventorySpace()
  local slotCount = getFreeSlotCount()
  local bag, slot, id = Scrap:IterateJunk()()

  if slotCount < THRESHOLD and bag ~= nil and slot ~= nil then
    b:Show()
  else
    b:Hide()
  end

  return slotCount;
end

local function inventoryChangedHandler(self, event, container)
  local slots, type = GetContainerNumFreeSlots(container)
  if type == 0 then
    checkInventorySpace()
  end
end

local function onLoad()
  local frame = CreateFrame("FRAME");
  frame:RegisterEvent("ITEM_PUSH");
  frame:RegisterEvent("BAG_UPDATE");
  frame:SetScript("OnEvent", inventoryChangedHandler);
end

if Scrap then
  onLoad()
else
  local frame = CreateFrame("FRAME");
  frame:RegisterEvent("ADDON_LOADED");
  frame:SetScript("OnEvent", addonLoadedHandler);
end
