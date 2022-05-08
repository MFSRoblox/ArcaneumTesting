local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GlobalModuleName = "Arcaneum"
local ArcaneumGlobals repeat
    ArcaneumGlobals = ReplicatedStorage:FindFirstChild(GlobalModuleName)
    if ArcaneumGlobals == nil then
        task.wait(1)
    else
        ArcaneumGlobals = require(ArcaneumGlobals)
        ArcaneumGlobals:CheckVersion("1.1.0")
    end
until ArcaneumGlobals ~= nil
local ClassService = ArcaneumGlobals:GetGlobal("ClassService")
ClassService:CheckVersion("1.1.0")
local Class = ClassService:GetClass("Class")
Class:CheckVersion("1.2.0")
local TestCollectionClass = require(script.TestCollection)
--[=[
    @server
    @client
    @class ArcaneumTesting
    A module that allows you to create and run tests on the environment. It is designed to test and use the ArcaneumFramework.
]=]
local ArcaneumTesting: ArcaneumTesting = Class:Extend(
    {
        ClassName = "ArcaneumTestingervice";
        ArcaneumGlobals = ArcaneumGlobals;
        Version = "1.0.0";
        CoreModule = script;
        TestCollections = {};
    }
)
export type ArcaneumTesting = {
    TestCollections: Dictionary<TestCollectionClass.TestCollection>;
} & typeof(ArcaneumTesting) & typeof(Class)
local TestInfoInterface = require(script.TestCollection.TestInfoInterface)
--[=[
    A wrapper for creating new Tests. Refer to [TestInfoInterface.new].
]=]
function ArcaneumTesting.NewTest(NewInfo: TestInfoInterface.TestInfo): TestInfoInterface.TestInfo
    return TestInfoInterface.new(NewInfo)
end
function ArcaneumTesting:New(Tests: Folder?): ArcaneumTesting
    local NewBot = self:Extend({});
    local TestCollections = {}
    TestCollections.GlobalTests = TestCollectionClass:New("GlobalTests",script.GlobalTests);
    local TestModulesFolder = Tests do
        if TestModulesFolder then
            TestCollections.OtherTests = TestCollectionClass:New(Tests.Name,Tests);
        end
    end
    NewBot.TestCollections = TestCollections
    return NewBot
end

function ArcaneumTesting:Run()
    local TestCollections = self.TestCollections
    local FailedCounter, WarnCounter, SkippedCounter = TestCollections.GlobalTests:Run()
    if TestCollections.OtherTests ~= nil then
        local OtherFailed, OtherWarn, OtherSkipped = TestCollections.OtherTests:Run()
        FailedCounter += OtherFailed
        WarnCounter += OtherWarn
        SkippedCounter += OtherSkipped
    end
    print(FailedCounter,"failed,", WarnCounter, "issue(s),", SkippedCounter, "skipped")
    self:Destroy()
end

function ArcaneumTesting:Destroy()
    for _,v in pairs(self.TestCollections) do
        v:Destroy()
    end
    return Class.Destroy(self)
end

return ArcaneumTesting