import { FooDoesNothing } from "./foo";

export function testDoesSomething() {
    if (FooDoesNothing() === 'nothing') {
        return true;
    }
    return false;
}

(window as any).annex = testDoesSomething;