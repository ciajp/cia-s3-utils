require 'spec_helper'

describe Cia::S3::Utils::S3Upload do

    let(:test_zip) { File.expand_path("../../../fixtures/test.zip", File.dirname(__FILE__)) }
    let(:unnecessary_zip) { File.expand_path("../../../fixtures/unnecessary.zip", File.dirname(__FILE__)) }

    before(:each) do 
        allow_any_instance_of(AWS::S3::S3Object).to receive(:write) do 
            p "stub doing."
        end
    end

    describe 'upload!' do
        it 'should call Zip::InputStream' do
            count = 0
            allow_any_instance_of(Zip::InputStream).to receive(:read) { count += 1 }
            uploader = Cia::S3::Utils::S3Upload.new("bucket_name", "stored_dir")
            uploader.upload!(test_zip, true, 1)
            expect(count).to be > 0
        end

        it 'should have default 5 threads' do
            uploader = Cia::S3::Utils::S3Upload.new("bucket_name", "stored_dir")
            uploader.upload!(test_zip)
            expect(uploader.threads.count).to eq(5)
        end

        it 'should reject unnecessary files and folders' do
            expect(Zip::File).to receive(:open)
            uploader = Cia::S3::Utils::S3Upload.new("bucket_name", "stored_dir")
            uploader.upload!(unnecessary_zip, true)
            uploader.uploaded_file.each do | f |
                expect("#{f}").not_to include("DS_Store")
                expect("#{f}").not_to include("__MACOSX")
            end
        end

        describe 'not zip' do 

            it 'should be count one ' do
                spec_helper_file = File.read(File.expand_path("../../../spec_helper.rb", File.dirname(__FILE__)))
                expect(File).to receive(:open).with(spec_helper_file)
                uploader = Cia::S3::Utils::S3Upload.new("bucket_name", "stored_dir")
                uploader.upload!(spec_helper_file)
                expect(uploader.total_files).to eq(1)
            end

        end

        describe "progress count" do 
            it 'should be up to total_files count' do 
                progress_hash = {}
                uploader = Cia::S3::Utils::S3Upload.new("bucket_name", "stored_dir", progress_hash)
                uploader.upload!(test_zip)
                expect(uploader.total_files).to eq progress_hash[Cia::S3::Utils::S3Upload::PROGRESS_KEY]
            end
        end

        describe "yield block" do 
            it 'should call block' do 
                expect(Kernel).to receive(:p).at_least(:once)
                uploader = Cia::S3::Utils::S3Upload.new("bucket_name", "stored_dir")
                uploader.upload!(test_zip) { | progress, total |
                    Kernel.p "#{progress} / #{total}"
                }
            end
        end
    end

    describe "delete" do
        before(:each) do 
            allow_any_instance_of(AWS::S3::ObjectCollection).to receive(:with_prefix).and_return(
                [
                    AWS::S3::S3Object.new("bucket_name", "tmp/"),
                    AWS::S3::S3Object.new("bucket_name", "var/"),
                    AWS::S3::S3Object.new("bucket_name", "etc/")
                ]
            )
            allow_any_instance_of(AWS::S3::S3Object).to receive(:delete) do 
                p "stub doing."
            end
        end

        it 'should be deleted' do
            uploader = Cia::S3::Utils::S3Upload.new("bucket_name", "stored_dir")
            expect(uploader.delete("tmp")).to eq 3
        end

        context "exclude_path is String" do 
            it 'should be remained when exclude_path was given' do
                uploader = Cia::S3::Utils::S3Upload.new("bucket_name", "stored_dir")
                expect(uploader.delete("tmp", "var")).to eq 2
            end
        end
        context "exclude_path is Array" do 
            it 'should be remained when exclude_paths was given' do
                uploader = Cia::S3::Utils::S3Upload.new("bucket_name", "stored_dir")
                expect(uploader.delete("tmp", ["var"])).to eq 2
            end
        end

    end

    describe "restrict_acl" do 
        it "should call S3Object.acl=" do 
            allow_any_instance_of(AWS::S3::S3Object).to receive(:exists?).and_return(true)
            expect_any_instance_of(AWS::S3::S3Object).to receive(:acl=).with(:private)
            uploader = Cia::S3::Utils::S3Upload.new("bucket_name")
            uploader.restrict_acl("path")
        end
    end

    describe "url_for" do
        it "should call S3Object.url_for" do 
            allow_any_instance_of(AWS::S3::S3Object).to receive(:exists?).and_return(true)
            expect_any_instance_of(AWS::S3::S3Object).to receive(:url_for).with(:read)
            uploader = Cia::S3::Utils::S3Upload.new("bucket_name")
            uploader.url_for("path")
        end
    end

    describe "publish" do
        it "should call S3Object.acl= with :public_read" do
            allow_any_instance_of(AWS::S3::S3Object).to receive(:exists?).and_return(true)
            expect_any_instance_of(AWS::S3::S3Object).to receive(:acl=).with(:public_read)
            uploader = Cia::S3::Utils::S3Upload.new("bucket_name")
            uploader.publish("path")
        end
    end
end 