#!/usr/bin/env bun
import { hyperLayer, ifVar, layer, map, modifierLayer, rule, toSetVar, writeToProfile } from 'karabiner.ts';

writeToProfile('Default profile', [
    rule("ctrl_layer").manipulators([
        map("caps_lock").to("left_control"),
        map("left_control").to(toSetVar("layer", 1)).toAfterKeyUp(toSetVar("layer", 0)),

        map("i","optionalAny").to("up_arrow").condition(ifVar("layer", 1)),
        map("k","optionalAny").to("down_arrow").condition(ifVar("layer", 1)),
        map("j","optionalAny").to("left_arrow").condition(ifVar("layer", 1)),
        map("l","optionalAny").to("right_arrow").condition(ifVar("layer", 1)),

        map("a").to("a","left_control").condition(ifVar("layer", 1)), // 先に宣言した方が優先
        map("a","optionalAny").to("home").condition(ifVar("layer", 1)),

        map("e").to("e","left_control").condition(ifVar("layer", 1)), // 先に宣言した方が優先
        map("e","optionalAny").to("end").condition(ifVar("layer", 1)),
        map("w","optionalAny").to("escape").condition(ifVar("layer", 1)),
        map("f","optionalAny").to("return_or_enter").condition(ifVar("layer", 1)),
        map("d","optionalAny").to("delete_forward").condition(ifVar("layer", 1)),
        map("s","optionalAny").to("delete_or_backspace").condition(ifVar("layer", 1)),

        map("c").to("c","left_control").condition(ifVar("layer", 1)),
    ]),
    ]);