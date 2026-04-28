import Testing
@testable import LiquidGlassBackport

@Test("All mandatory backport modules are linked")
func linkedModulesContainRequiredDependencies() {
    #expect(LiquidGlassBackport.linkedModules() == [
        "Backport",
        "ButtonStyleBackport",
        "GlassBackport"
    ])
}
