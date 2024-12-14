import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { SearchAndWindows } from "./windowcontent.js";
import PopupWindow from '../.widgethacks/popupwindow.js';

const OptionalOverview = async () => {
    try {
        return (await import('./overview_hyprland.js')).default();
    } catch {
        return Widget.Box({});
        // return (await import('./overview_hyprland.js')).default();
    }
};

const overviewContent = await OptionalOverview();

export default (id = '') => PopupWindow({
    name: `overview${id}`,
    exclusivity: 'ignore',
    keymode: 'exclusive',
    visible: false,
    // anchor: ['middle'],
    layer: 'overlay',
    child: Widget.Box({
        vertical: true,
        children: [
            //SearchAndWindows(),
            overviewContent,
        ]
    }),
})
