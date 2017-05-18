local dataMax = require ("plugin.dataMax")
local widget = require("widget")
local bg = display.newRect( display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
bg:setFillColor( .4,0,0 )

local title = display.newText( "Data Max Plugin", display.contentCenterX, 50, native.systemFontBold, 25 )
local description = display.newText( "Click on which printer and printer type you would like to print test file from", display.contentCenterX, 100, 240, 50, native.systemFont, 12)
timer.performWithDelay( 1000, function ( )
    if system.getInfo("environment") == "device" and dataMax.isBluetoothOn() == false then
--        native.showAlert( "Enable bluetooth", "Please enabled to bluetooth to use", {"Ok"} )
    end
end)

local printerType = widget.newSegmentedControl(
    {
        x = display.contentCenterX,
        y = 140,
        segmentWidth = 80,
        segments = { "apex", "legacy", "DPL"},
        defaultSegment = 1,
        onPress = function ( e )
        	
        end
    }
)
local printers = widget.newTableView( {
	x = display.contentCenterX,
	y = display.contentCenterY+80,
	width = 240,
	height = 300,
	onRowRender = function ( e )
		local row = e.row
 
	    local rowHeight = row.contentHeight
	    local rowWidth = row.contentWidth
	 
	    local rowTitle = display.newText( row, row.params.name, 0, 0, nil, 14 )
	    rowTitle:setFillColor( 0 )
 
    	rowTitle.anchorX = 0
    	rowTitle.x = 0
	    rowTitle.y = rowHeight * 0.5
	end,
	listener = function ( e )
		if (e.target.params and e.target.params.name) then
			if (e.phase == "began") then
				e.target.alpha = .3
			elseif (e.phase == "ended") then
				e.target.alpha = 1
				dataMax.print(e.target.params.name , e.target.params.modelNumber, printerType.segmentLabel, system.pathForFile( "sample.pdf" ), 832, function ( e )
					print( e.status )
					native.showAlert( "Status", e.status, {"Ok" } )
				end, true)
			end	
		end
	end
} )

timer.performWithDelay( 1000, function ( )
	local myPrinters = dataMax.getPrinters()
	for i=1,#myPrinters do
		printers:deleteAllRows()
		printers:insertRow(
        {
        	params = {name = myPrinters[i].name, modelNumber = myPrinters[i].modelNumber}
    	})
	end
end, -1 )
