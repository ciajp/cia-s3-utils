require 'spec_helper'

describe Cia::S3::Utils::S3Download do

    before(:each) do 
    end

    describe 'download' do
        it "should has download method" do 
            downloader = Cia::S3::Utils::S3Download.new("bucket_name")
            expect(downloader).to respond_to(:download)
        end

        describe "object exists" do
            it 'should return AWS::S3::S3Object' do
                allow_any_instance_of(AWS::S3::S3Object).to receive(:exists?).and_return(true)
                downloader = Cia::S3::Utils::S3Download.new("bucket_name")
                ret = downloader.download("test")
                expect(ret).not_to be_nil
                expect(ret).to be_a(AWS::S3::S3Object)
            end
        end

        describe "object not exists" do
            it 'should return nil' do
                allow_any_instance_of(AWS::S3::S3Object).to receive(:exists?).and_return(false)
                downloader = Cia::S3::Utils::S3Download.new("bucket_name")
                ret = downloader.download("test")
                expect(ret).to be_nil
            end
        end
    end
end 